variable "src_container_port" {
  type        = string
  description = "Port of src fastapi that it is listening on"
}
variable "dashboard_container_port" {
  type        = string
  description = "Port of Dashboard API that it is listening on"
}

variable "ecs-service-role-arn" {
  type        = string
  description = "IAM Role required for ECS Service"
}


variable "ecs-task-app-role-arn" {
  type        = string
  description = "ECS Task role for SQS"
}

variable "src-tg-arn" {
  type        = string
  description = "Src api Target Group ARN"
}

variable "dashboard-tg-arn" {
  type        = string
  description = "Dashboard API Target Group ARN"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private Subnet ID's"
}

variable "ecs_src_sg_id" {
  type        = string
  description = "ECS Src Container security group ID"
}

variable "ecs_dashboard_sg_id" {
  type        = string
  description = "ECS Dashboard Container security group ID"
}

variable "ecs_worker_sg_id" {
  type        = string
  description = "ECS worker container security group ID"
}

variable "db_username" {
  type        = string
  description = "The username for the RDS PostgreSQL database"
}

variable "db_password" {
  type        = string
  description = "The password for the RDS PostgreSQL database"
  sensitive   = true
}

variable "db_endpoint" {
  type        = string
  description = "The connection endpoint for the RDS database (host:port)"
}

variable "db_name" {
  type        = string
  description = "The default database name"
}

variable "sqs_url" {
  type        = string
  description = "SQL URL"
}
