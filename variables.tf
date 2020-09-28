#################
# Security group
#################
variable "create" {
  description = "Whether to create security group and all rules"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
}

variable "name" {
  description = "Name of resources acts as a prefix"
  type        = string
}

variable "description" {
  description = "Description of security group"
  type = string
  default = "Security Group managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "security_group_tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "alb_tags" {
  description = "A mapping of tags to assign to alb"
  type        = map(string)
  default     = {}
}

variable "s3_tags" {
  type = map(string)
  default = {}
  description = "Tags to apply specifically to s3 logging bucket"
}
##########
# Ingress
##########
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_with_self" {
  description = "List of ingress rules to create where 'self' is defined"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  type        = list(map(string))
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

#########
# Egress
#########
variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = [
    {
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

variable "egress_with_self" {
  description = "List of egress rules to create where 'self' is defined"
  type        = list(map(string))
  default     = []
}

variable "subnets" {
  type = list(string)
  description = "List of subnets for the alb"
}


variable "enable_alb_logging" {
  default = true
  description = "Enable ALB Access logs to s3"
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = map(string)
  default     = {}
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to http_tcp_listeners[count.index])"
  type        = any
  default     = []
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  description = "AWS SSL Policy for SSL"
  type = string
}

variable "internal" {
  default = true
  description = "Defines internal or external ALB"
  type = bool
}

variable "instance_id" {
  description = "Instance ID to assign target groups too"
  type = string
  default = ""
}