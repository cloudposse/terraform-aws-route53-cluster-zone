provider "aws" {
  region = var.region
}

module "domain" {
  source                     = "../../"
  context                    = module.this.context
  zone_name                  = var.zone_name
  parent_zone_record_enabled = false
}
