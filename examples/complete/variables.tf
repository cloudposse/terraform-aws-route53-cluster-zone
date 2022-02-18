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
