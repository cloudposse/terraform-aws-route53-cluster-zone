locals {
  enabled                    = module.this.enabled
  parent_zone_record_enabled = local.enabled && var.parent_zone_record_enabled
  public_zone                = try(length(var.private_hosted_zone_vpc_attachments), 0) == 0
}

data "aws_region" "default" {
  count = local.enabled ? 1 : 0
}

data "aws_route53_zone" "parent_zone" {
  count   = local.parent_zone_record_enabled ? 1 : 0
  zone_id = var.parent_zone_id
  name    = var.parent_zone_name
}

resource "aws_route53_zone" "default" {
  count = local.enabled ? 1 : 0

  # https://github.com/hashicorp/terraform/issues/26838#issuecomment-840022506
  name = replace(replace(replace(replace(replace(replace(replace(replace(var.zone_name,
    "$${namespace}", module.this.namespace),
    "$${environment}", module.this.environment),
    "$${name}", module.this.name),
    "$${stage}", module.this.stage),
    "$${id}", module.this.id),
    "$${attributes}", join(module.this.delimiter, module.this.attributes)),
    "$${parent_zone_name}", coalesce(join("", data.aws_route53_zone.parent_zone.*.name), var.parent_zone_name)),
  "$${region}", join("", data.aws_region.default.*.name))

  dynamic "vpc" {
    for_each = var.private_hosted_zone_vpc_attachments
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region
    }
  }

  tags = module.this.tags
}

resource "aws_route53_record" "ns" {
  count   = local.parent_zone_record_enabled && local.public_zone ? 1 : 0
  zone_id = join("", data.aws_route53_zone.parent_zone.*.zone_id)
  name    = join("", aws_route53_zone.default.*.name)
  type    = "NS"
  ttl     = "60"

  records = [
    aws_route53_zone.default[0].name_servers[0],
    aws_route53_zone.default[0].name_servers[1],
    aws_route53_zone.default[0].name_servers[2],
    aws_route53_zone.default[0].name_servers[3],
  ]
}

# Attempting to create an SOA for a private zone will fail with:
# FATAL problem: DomainLabelEmpty (Domain label is empty)
resource "aws_route53_record" "soa" {
  count           = local.enabled && local.public_zone ? 1 : 0
  allow_overwrite = true
  zone_id         = join("", aws_route53_zone.default.*.id)
  name            = join("", aws_route53_zone.default.*.name)
  type            = "SOA"
  ttl             = "30"

  records = [
    format("%s. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400", aws_route53_zone.default[0].name_servers[0])
  ]
}
