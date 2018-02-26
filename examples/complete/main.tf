module "domain" {
  source           = "../../"
  namespace        = "example"
  stage            = "dev"
  name             = "cluster"
  parent_zone_name = "example.com"
  zone_name        = "$${name}.$${stage}.$${parent_zone_name}"
}
