variable "region" {
  type        = string
  description = "AWS region"
}

variable "secondary_region" {
  type        = string
  description = "Second AWS region for testing multi-zone private hosted zone"
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

variable "private_zone_test_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable the private zone test"
}