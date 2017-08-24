variable "namespace" {}

variable "stage" {}

variable "name" {}

variable "zone_name" {
  default = "$${stage}.$${parent_zone_name}"
}

variable "parent_zone_id" {
  default = ""
}

variable "parent_zone_name" {
  default = ""
}

variable "ttl" {
  default = "300"
}
