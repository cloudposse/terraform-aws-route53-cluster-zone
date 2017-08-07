variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "domain"
}

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
