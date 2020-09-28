## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_logs | n/a | `map(string)` | `{}` | no |
| alb\_tags | A mapping of tags to assign to alb | `map(string)` | `{}` | no |
| create | Whether to create security group and all rules | `bool` | `true` | no |
| description | Description of security group | `string` | `"Security Group managed by Terraform"` | no |
| egress\_with\_cidr\_blocks | List of egress rules to create where 'cidr\_blocks' is used | `list(map(string))` | <pre>[<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": "0",<br>    "protocol": "-1",<br>    "to_port": "0"<br>  }<br>]</pre> | no |
| egress\_with\_self | List of egress rules to create where 'self' is defined | `list(map(string))` | `[]` | no |
| http\_tcp\_listeners | A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target\_group\_index (defaults to http\_tcp\_listeners[count.index]) | `any` | `[]` | no |
| https\_listeners | A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate\_arn. Optional key/values: ssl\_policy (defaults to ELBSecurityPolicy-2016-08), target\_group\_index (defaults to https\_listeners[count.index]) | `any` | `[]` | no |
| ingress\_cidr\_blocks | List of IPv4 CIDR ranges to use on all ingress rules | `list(string)` | `[]` | no |
| ingress\_rules | List of ingress rules to create by name | `list(string)` | `[]` | no |
| ingress\_with\_cidr\_blocks | List of ingress rules to create where 'cidr\_blocks' is used | `list(map(string))` | `[]` | no |
| ingress\_with\_self | List of ingress rules to create where 'self' is defined | `list(map(string))` | `[]` | no |
| ingress\_with\_source\_security\_group\_id | List of ingress rules to create where 'source\_security\_group\_id' is used | `list(map(string))` | `[]` | no |
| instance\_ids | Instance IDs to assign target groups too | `set(string)` | n/a | yes |
| internal | Defines internal or external ALB | `bool` | `true` | no |
| name | Name of security group | `string` | n/a | yes |
| ssl\_policy | AWS SSL Policy for SSL | `string` | `"ELBSecurityPolicy-FS-1-2-Res-2019-08"` | no |
| subnet\_tags | A mapping of tags to assign to security group | `map(string)` | `{}` | no |
| subnets | List of subnets for the alb | `list(string)` | n/a | yes |
| tags | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |
| target\_groups | A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend\_protocol, backend\_port | `any` | `[]` | no |
| vpc\_id | ID of the VPC where to create security group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| alb\_arn | n/a |
| sg\_id | n/a |

