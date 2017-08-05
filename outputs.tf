output "parent_zone_id" {
  value = "${null_resource.parent.triggers.zone_id}"
}

output "parent_zone_name" {
  value = "${null_resource.parent.triggers.zone_name}"
}

output "zone_id" {
  value = "${aws_route53_zone.default.zone_id}"
}

output "fqdn" {
  value = "${aws_route53_zone.default.name}"
}
