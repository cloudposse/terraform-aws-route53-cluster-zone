variable "namespace" {
  default = "global"
}

variable "provider" {}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "domain"
}

variable "parent_zone_id" {
  default = ""
}

variable "ttl" {
  default = "300"
}
