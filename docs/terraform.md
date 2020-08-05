## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, < 0.14.0 |
| aws | ~> 2.0 |
| null | ~> 2.0 |
| template | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |
| template | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| enabled | Set to false to prevent the module from creating or accessing any resources | `bool` | `true` | no |
| name | The Name of the application or solution  (e.g. `bastion` or `portal`) | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | n/a | yes |
| parent\_zone\_id | ID of the hosted zone to contain this record  (or specify `parent_zone_name`) | `string` | `""` | no |
| parent\_zone\_name | Name of the hosted zone to contain this record (or specify `parent_zone_id`) | `string` | `""` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| tags | Additional tags (e.g. map('BusinessUnit','XYZ') | `map(string)` | `{}` | no |
| zone\_name | Zone name | `string` | `"$${name}.$${stage}.$${parent_zone_name}"` | no |

## Outputs

| Name | Description |
|------|-------------|
| fqdn | Fully-qualified domain name |
| parent\_zone\_id | ID of the hosted zone to contain this record |
| parent\_zone\_name | Name of the hosted zone to contain this record |
| zone\_id | Route53 DNS Zone ID |
| zone\_name | Route53 DNS Zone name |

