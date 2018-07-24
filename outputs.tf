output "parent_zone_id" {
  value       = "${null_resource.parent.triggers.zone_id}"
  description = "ID of the hosted zone to contain this record  (or specify `parent_zone_name`)"
}

output "parent_zone_name" {
  value       = "${null_resource.parent.triggers.zone_name}"
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}

output "zone_id" {
  value       = "${aws_route53_zone.default.zone_id}"
  description = "Route53 DNS Zone id"
}

output "zone_name" {
  value       = "${replace(aws_route53_zone.default.name, "/\\.$$/", "")}"
  description = "Zone name"
}

output "fqdn" {
  value       = "${aws_route53_zone.default.name}"
  description = "Fully-qualified domain name"
}
