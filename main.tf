# Define composite variables for resources
module "label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
}

data "template_file" "zone_name" {
  template = "${replace(var.zone_name, "$$$$", "$")}"

  vars {
    namespace        = "${var.namespace}"
    name             = "${var.name}"
    stage            = "${var.stage}"
    id               = "${module.label.id}"
    parent_zone_name = "${null_resource.parent.triggers.zone_name}"
  }
}

resource "null_resource" "parent" {
  triggers = {
    zone_id   = "${format("%v", length(var.parent_zone_id) > 0 ? join(" ", data.aws_route53_zone.parent_by_zone_id.*.zone_id) : join(" ", data.aws_route53_zone.parent_by_zone_name.*.zone_id) )}"
    zone_name = "${format("%v", length(var.parent_zone_id) > 0 ? join(" ", data.aws_route53_zone.parent_by_zone_id.*.name) : join(" ", data.aws_route53_zone.parent_by_zone_name.*.name) )}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "parent_by_zone_id" {
  count   = "${signum(length(var.parent_zone_id))}"
  zone_id = "${var.parent_zone_id}"
}

data "aws_route53_zone" "parent_by_zone_name" {
  count = "${signum(length(var.parent_zone_name))}"
  name  = "${var.parent_zone_name}"
}

resource "aws_route53_zone" "default" {
  name = "${data.template_file.zone_name.rendered}"
  tags = "${module.label.tags}"
}

resource "aws_route53_record" "ns" {
  zone_id = "${null_resource.parent.triggers.zone_id}"
  name    = "${aws_route53_zone.default.name}"
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
  zone_id = "${aws_route53_zone.default.id}"
  name    = "${aws_route53_zone.default.name}"
  type    = "SOA"
  ttl     = "30"

  records = [
    "${aws_route53_zone.default.name_servers.0}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}
