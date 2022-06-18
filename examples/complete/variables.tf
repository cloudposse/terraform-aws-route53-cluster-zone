variable "region" {
  type        = string
  description = "AWS region"
}

variable "parent_zone_name" {
  type        = string
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}

variable "ns_record_ttl" {
  type        = number
  description = "The time to live (TTL) of the nameserver Route53 record, in seconds."
}

variable "soa_record_ttl" {
  type        = number
  description = "The time to live (TTL) of the start of authority Route53 record, in seconds."
}
