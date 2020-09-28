output "alb_arn" {
  value = module.alb.this_lb_arn
}

output "sg_id" {
  value = module.security_group.this_security_group_id
}