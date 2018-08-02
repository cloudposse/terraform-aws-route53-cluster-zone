variable "name" {
  description = "The Name of the application or solution  (e.g. `bastion` or `portal`)"
}

variable "namespace" {
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "zone_name" {
  default     = "$${name}.$${stage}.$${parent_zone_name}"
  description = "Zone name"
}

variable "parent_zone_id" {
  default     = ""
  description = "ID of the hosted zone to contain this record  (or specify `parent_zone_name`)"
}

variable "parent_zone_name" {
  default     = ""
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit','XYZ')"
}

variable "enabled" {
  default     = "true"
  description = "Set to false to prevent the module from creating or accessing any resources"
}
