provider "aws" {
  region = var.region
}

module "domain" {
  source           = "../../"
  namespace        = var.namespace
  stage            = var.stage
  name             = var.name
  parent_zone_name = var.parent_zone_name
  zone_name        = "$${name}.$${parent_zone_name}"
}
