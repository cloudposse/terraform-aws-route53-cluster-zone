output "parent_zone_id" {
  value = "${data.aws_route53_zone.parent.zone_id}"
}

output "parent_zone_name" {
  value = "${data.aws_route53_zone.parent.name}"
}

output "zone_id" {
  value = "${aws_route53_zone.default.zone_id}"
}

output "fqdn" {
  value = "${aws_route53_zone.default.name}"
}
