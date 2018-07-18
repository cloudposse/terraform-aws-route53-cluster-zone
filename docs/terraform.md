
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, `attributes` | string | `-` | no |
| name | The Name of the application or solution  (e.g. `bastion` or `portal`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| parent_zone_id | ID of the hosted zone to contain this record  (or specify `parent_zone_name`) | string | `` | no |
| parent_zone_name |  | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map('BusinessUnit','XYZ') | map | `<map>` | no |
| zone_name | Zone name | string | `$${stage}.$${parent_zone_name}` | no |

## Outputs

| Name | Description |
|------|-------------|
| fqdn | Fully-qualified domain name |
| parent_zone_id | ID of the hosted zone to contain this record  (or specify `parent_zone_name`) |
| parent_zone_name | Name of the hosted zone to contain this record (or specify `parent_zone_id`) |
| zone_id | Route53 DNS Zone id |
| zone_name | Zone name |
