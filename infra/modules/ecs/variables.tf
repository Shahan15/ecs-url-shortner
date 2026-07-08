variable "src_container_port" {
  type = string
  description = "port of src fastapi that it is listening on"
}

variable "ecs-iam-role" {
  type = string
  description = "IAM Role required for ECS Service"
}

variable "alb-target_group_arn" {
  type = string
  description = "ALB Target Group ARN"
}