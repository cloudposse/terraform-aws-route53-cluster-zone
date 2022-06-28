provider "aws" {
  region = var.region
}

module "domain" {
  source                     = "../../"
  context                    = module.this.context
  zone_name                  = "$${name}"
  parent_zone_record_enabled = false
}
