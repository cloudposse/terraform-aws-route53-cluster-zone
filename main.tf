module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.19.2"
  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
  enabled     = var.enabled
}

locals {
  enabled                    = var.enabled ? 1 : 0
  parent_zone_record_enabled = var.parent_zone_record_enabled && var.enabled ? 1 : 0
}

data "aws_region" "default" {
}

data "aws_route53_zone" "parent_zone" {
  count   = local.parent_zone_record_enabled
  zone_id = var.parent_zone_id
  name    = var.parent_zone_name
}

data "template_file" "zone_name" {
  count    = local.enabled
  template = replace(var.zone_name, "$$", "$")

  vars = {
    namespace        = var.namespace
    environment      = var.environment
    name             = var.name
    stage            = var.stage
    id               = module.label.id
    attributes       = join(var.delimiter, module.label.attributes)
    parent_zone_name = coalesce(join("", data.aws_route53_zone.parent_zone.*.name), var.parent_zone_name)
    region           = data.aws_region.default.name
  }
}

resource "aws_route53_zone" "default" {
  count = local.enabled
  name  = join("", data.template_file.zone_name.*.rendered)
  tags  = module.label.tags
}

resource "aws_route53_record" "ns" {
  count   = local.parent_zone_record_enabled
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

resource "aws_route53_record" "soa" {
  count           = local.enabled
  allow_overwrite = true
  zone_id         = join("", aws_route53_zone.default.*.id)
  name            = join("", aws_route53_zone.default.*.name)
  type            = "SOA"
  ttl             = "30"

  records = [
    format("%s. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400", aws_route53_zone.default[0].name_servers[0])
  ]
}
