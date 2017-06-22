output "zone_id" {
  value = "${aws_route53_zone.default.zone_id}"
}

output "fqdn" {
  value = "${aws_route53_zone.default.name}"
}
