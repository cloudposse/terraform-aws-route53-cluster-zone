module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
  enabled    = "${var.enabled}"
}

data "template_file" "zone_name" {
  count    = "${var.enabled == "true" ? 1 : 0}"
  template = "${replace(var.zone_name, "$$$$", "$")}"

  vars {
    namespace        = "${var.namespace}"
    name             = "${var.name}"
    stage            = "${var.stage}"
    id               = "${module.label.id}"
    attributes       = "${module.label.attributes}"
    parent_zone_name = "${join("", null_resource.parent.*.triggers.zone_name)}"
  }
}

resource "null_resource" "parent" {
  count = "${var.enabled == "true" ? 1 : 0}"

  triggers = {
    zone_id   = "${format("%v", length(var.parent_zone_id) > 0 ? join(" ", data.aws_route53_zone.parent_by_zone_id.*.zone_id) : join(" ", data.aws_route53_zone.parent_by_zone_name.*.zone_id) )}"
    zone_name = "${format("%v", length(var.parent_zone_id) > 0 ? join(" ", data.aws_route53_zone.parent_by_zone_id.*.name) : join(" ", data.aws_route53_zone.parent_by_zone_name.*.name) )}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "parent_by_zone_id" {
  count   = "${var.enabled == "true" ? signum(length(var.parent_zone_id)) : 0}"
  zone_id = "${var.parent_zone_id}"
}

data "aws_route53_zone" "parent_by_zone_name" {
  count = "${var.enabled == "true" ? signum(length(var.parent_zone_name)) : 0}"
  name  = "${var.parent_zone_name}"
}

resource "aws_route53_zone" "default" {
  count = "${var.enabled == "true" ? 1 : 0}"
  name  = "${join("", data.template_file.zone_name.*.rendered)}"
  tags  = "${module.label.tags}"
}

resource "aws_route53_record" "ns" {
  count   = "${var.enabled == "true" ? 1 : 0}"
  zone_id = "${join("", null_resource.parent.*.triggers.zone_id)}"
  name    = "${join("", aws_route53_zone.default.*.name)}"
  type    = "NS"
  ttl     = "60"

  records = [
    "${aws_route53_zone.default.name_servers.0}",
    "${aws_route53_zone.default.name_servers.1}",
    "${aws_route53_zone.default.name_servers.2}",
    "${aws_route53_zone.default.name_servers.3}",
  ]
}

resource "aws_route53_record" "soa" {
  count   = "${var.enabled == "true" ? 1 : 0}"
  zone_id = "${join("", aws_route53_zone.default.*.id)}"
  name    = "${join("", aws_route53_zone.default.*.name)}"
  type    = "SOA"
  ttl     = "30"

  records = [
    "${aws_route53_zone.default.name_servers.0}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}
