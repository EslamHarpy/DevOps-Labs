output "load_balancer_dns" {
  value = module.ec2.alb_dns_name
}

output "database_endpoint" {
  value = module.rds.db_endpoint
}

output "vpc_id" {
  value = module.vpc.vpc_id
}