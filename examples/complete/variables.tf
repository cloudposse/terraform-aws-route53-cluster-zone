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
  description = "Parent zone name"
}

variable "private_zone_test_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable the private zone test"
}