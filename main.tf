locals {
  enabled                    = module.this.enabled ? 1 : 0
  parent_zone_record_enabled = var.parent_zone_record_enabled && module.this.enabled ? 1 : 0
  zone_name                  = local.parent_zone_record_enabled == 1 ? var.zone_name : replace(var.zone_name, ".$${parent_zone_name}", "")
}

data "aws_region" "default" {}

data "aws_route53_zone" "parent_zone" {
  count   = local.parent_zone_record_enabled
  zone_id = var.parent_zone_id
  name    = var.parent_zone_name
}

resource "aws_route53_zone" "default" {
  count = local.enabled

  # https://github.com/hashicorp/terraform/issues/26838#issuecomment-840022506
  name = replace(replace(replace(replace(replace(replace(replace(replace(replace(local.zone_name,
    "$${namespace}", module.this.namespace),
    "$${tenant}", module.this.tenant),
    "$${environment}", module.this.environment),
    "$${name}", module.this.name),
    "$${stage}", module.this.stage),
    "$${id}", module.this.id),
    "$${attributes}", join(module.this.delimiter, module.this.attributes)),
    "$${parent_zone_name}", coalesce(join("", data.aws_route53_zone.parent_zone.*.name), var.parent_zone_name, "none")),
  "$${region}", data.aws_region.default.name)

  tags = module.this.tags
}

resource "aws_route53_record" "ns" {
  count   = local.parent_zone_record_enabled
  zone_id = join("", data.aws_route53_zone.parent_zone.*.zone_id)
  name    = join("", aws_route53_zone.default.*.name)
  type    = "NS"
  ttl     = var.ns_record_ttl

  records = [
    aws_route53_zone.default[0].name_servers[0],
    aws_route53_zone.default[0].name_servers[1],
    aws_route53_zone.default[0].name_servers[2],
    aws_route53_zone.default[0].name_servers[3],
  ]
}

resource "aws_route53_record" "soa" {
  count           = local.enabled
  allow_overwrite = true
  zone_id         = join("", aws_route53_zone.default.*.id)
  name            = join("", aws_route53_zone.default.*.name)
  type            = "SOA"
  ttl             = var.soa_record_ttl

  records = [
    format("%s. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400", aws_route53_zone.default[0].name_servers[0])
  ]
}
