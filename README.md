# terraform-aws-route53-cluster-zone [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-route53-cluster-zone.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-route53-cluster-zone)

Terraform module to easily define consistent cluster domains on `Route53`.


## Usage

Define a cluster domain of `foobar.example.com` using a custom naming convention for `zone_name`.
The `zone_name` variable is optional. It defaults to `$${stage}.$${parent_zone_name}`.

```hcl
module "domain" {
  source               = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-zone.git?ref=master"
  namespace            = "example"
  stage                = "dev"
  name                 = "foobar"
  parent_zone_name     = "example.com"
  zone_name            = "$${name}.$${stage}.$${parent_zone_name}"
}
```


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
