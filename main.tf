# Define composite variables for resources
module "label" {
  source = "git::https://github.com/cloudposse/tf_label.git?ref=master"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
}

data "aws_route53_zone" "parent" {
  zone_id = "${var.parent_zone_id}"
  name = "${var.parent_zone_name}"
}

resource "aws_route53_zone" "default" {
  name = "${var.stage}.${data.aws_route53_zone.parent.name}"
  tags = "${module.label.tags}"
}

resource "aws_route53_record" "ns" {
  zone_id = "${var.parent_zone_id}"
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
