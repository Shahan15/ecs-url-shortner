output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
  description = "ALB Security Group"
}

output "ecs_src_sg_id" {
  value = aws_security_group.ecs_src_sg.id
  description = "ECS Src Container security group ID"
}

output "ecs_dashboard_sg_id" {
  value = aws_security_group.ecs_dashboard_sg.id
  description = "ECS Dashboard Container security group ID"
}

output "vpc_endpoints_sg" {
  value = aws_security_group.vpc_endpoints_sg.id
  description = "VPC Endpoint Security Group"
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
  description = "DB Security Group ID"
}