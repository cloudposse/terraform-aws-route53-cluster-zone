variable "name" {
  type        = string
  description = "The Name of the application or solution  (e.g. `bastion` or `portal`)"
}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "parent_zone_name" {
  type        = string
  description = "Parent zone name"
}
