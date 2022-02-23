variable "zone_name" {
  type        = string
  default     = "$${name}.$${stage}.$${parent_zone_name}"
  description = "Zone name"
}

variable "parent_zone_id" {
  type        = string
  default     = ""
  description = "ID of the hosted zone to contain this record  (or specify `parent_zone_name`)"
}

variable "parent_zone_name" {
  type        = string
  default     = ""
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}

variable "parent_zone_record_enabled" {
  type        = bool
  default     = true
  description = "Whether to create the NS record on the parent zone. Useful for creating a cluster zone across accounts. `var.parent_zone_name` required if set to false."
}

variable "ns_record_ttl" {
  type        = number
  default     = 60
  description = <<-EOT
  The time to live (TTL) of the nameserver Route53 record, in seconds.
  
  The default value for AWS-managed NS records is `172800`, but Cloud Posse prefers shorter TTLs as they result in better availability, despite not being optimal for caching.
  EOT
}

variable "soa_record_ttl" {
  type        = number
  default     = 30
  description = <<-EOT
  The time to live (TTL) of the start of authority Route53 record, in seconds.
  
  The default value for AWS-managed SOA records is `900`, but Cloud Posse prefers shorter TTLs as they result in better availability, despite not being optimal for caching.
  EOT
}
