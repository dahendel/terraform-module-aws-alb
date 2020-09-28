/*

This module wraps the official TF AWS security group and ALB module to also manage target groups when needed

*/
module "security_group" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "3.16.0"
    name = "${var.name}-sg"
    vpc_id = var.vpc_id
    ingress_with_self = var.ingress_with_self
    ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
    ingress_with_source_security_group_id = var.ingress_with_source_security_group_id
    ingress_cidr_blocks = var.ingress_cidr_blocks
    egress_with_cidr_blocks = var.egress_with_cidr_blocks
    egress_with_self = var.egress_with_self
    tags = merge(var.security_group_tags, var.tags)
}

module "s3_bucket_logs" {
    source = "terraform-aws-modules/s3-bucket/aws"
    version = "1.12.0"
    create_bucket = var.enable_alb_logging
    bucket = "${var.name}-alb-logs"
    acl    = "log-delivery-write"
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
    versioning = {
        enabled = true
    }
    force_destroy = true
    attach_elb_log_delivery_policy = true
    server_side_encryption_configuration = {
        rule = {
            apply_server_side_encryption_by_default = {
                sse_algorithm = "aws:kms"
            }
        }
    }

    tags = merge(var.tags, var.s3_tags)
}


module "alb" {
    source = "terraform-aws-modules/alb/aws"
    version = "~> 5.0"
    name = "${var.name}-alb"

    load_balancer_type = "application"

    vpc_id = var.vpc_id
    subnets = var.subnets
    security_groups = [
        module.security_group.this_security_group_id
    ]
    access_logs = var.enable_alb_logging ? {bucket = module.s3_bucket_logs.this_s3_bucket_id} : {}
    https_listeners = var.https_listeners
    http_tcp_listeners = var.http_tcp_listeners
    tags = merge(var.alb_tags, var.tags)
    enable_deletion_protection = false
    internal = var.internal
    listener_ssl_policy_default = var.ssl_policy
}

resource "aws_lb_target_group" "this" {
    for_each = var.target_groups
    name = each.key
    port = each.value["backend_port"]
    protocol = each.value["backend_protocol"]
    vpc_id = var.vpc_id
    health_check {
        enabled             = lookup(each.value, "enabled", null)
        interval            = lookup(each.value, "interval", null)
        path                = lookup(each.value, "path", null)
        port                = lookup(each.value, "backend_port", null)
        healthy_threshold   = lookup(each.value, "healthy_threshold", null)
        unhealthy_threshold = lookup(each.value, "unhealthy_threshold", null)
        timeout             = lookup(each.value, "timeout", null)
        protocol            = lookup(each.value, "protocol", null)
        matcher             = lookup(each.value, "matcher", null)
    }
}


resource "aws_lb_listener_rule" "host_based_weighted_routing" {
    for_each = var.target_groups
    listener_arn = element(module.alb.https_listener_arns, 0)

    condition {
        path_pattern {
            values = [each.value["path_pattern"]]
        }
    }

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.this[each.key].arn
    }
}

resource "aws_alb_target_group_attachment" "this" {
    for_each = var.target_groups
    target_group_arn = aws_lb_target_group.this[each.key].arn
    target_id = lookup(each.value, "instance_id", var.instance_id)


}