# tf_domain

Easily define consistent cluster domains on Route53.

## Usage

Define a cluster domain of `foobar.example.com` using a custom naming convention for `zone_name`.
The `zone_name` variable is optional. It defaults to `$${stage}.$${parent_zone_name}`.

```
module "domain" {
  source               = "git::https://github.com/cloudposse/tf_domain.git?ref=master"
  namespace            = "example"
  stage                = "dev"
  name                 = "foobar"
  parent_zone_name     = "example.com"
  zone_name            = "$${name}.$${stage}.$${parent_zone_name}"
}
```
