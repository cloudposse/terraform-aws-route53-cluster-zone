# tf_domain

Easily define consistent cluster domains on Route53.

## Usage

Define a cluster domain of `foobar.example.com`

```
module "domain" {
  source               = "git::https://github.com/cloudposse/tf_domain.git?ref=master"
  namespace            = "example"
  stage                = "dev"
  name                 = "foobar"
  parent_dns_zone_name = "example.com"
}
```
