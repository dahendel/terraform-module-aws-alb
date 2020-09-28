output "alb_outputs" {
  value = module.alb
}

output "sg_outputs" {
  value = module.security_group
}

output "s3_outputs" {
  value = module.s3_bucket_logs
}