provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "secondary_region"
  region = var.secondary_region
}

module "vpc_same_region" {
  source  = "cloudposse/vpc/aws"
  version = "0.28.1"

  enabled = module.this.enabled && var.private_zone_test_enabled

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "vpc_secondary_region" {
  providers = {
    aws = aws.secondary_region
  }

  source  = "cloudposse/vpc/aws"
  version = "0.28.1"

  enabled = module.this.enabled && var.private_zone_test_enabled

  cidr_block = "172.17.0.0/16"

  context = module.this.context
}

module "domain" {
  source           = "../../"
  context          = module.this.context
  parent_zone_name = var.parent_zone_name
  zone_name        = "$${name}.$${parent_zone_name}"
  ns_record_ttl    = var.ns_record_ttl
  soa_record_ttl   = var.soa_record_ttl

  private_hosted_zone_vpc_attachments = var.private_zone_test_enabled ? [
    {
      vpc_id     = module.vpc_same_region.vpc_id
      vpc_region = var.region
    },
    {
      vpc_id     = module.vpc_secondary_region.vpc_id
      vpc_region = var.secondary_region
    }
  ] : []
}
