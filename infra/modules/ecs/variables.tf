variable "src_container_port" {
  type = string
  description = "Port of src fastapi that it is listening on"
}
variable "dashboard_container_port" {
  type = string
  description = "Port of Dashboard API that it is listening on"
}

variable "ecs-service-role-arn" {
  type = string
  description = "IAM Role required for ECS Service"
}

variable "src-tg-arn" {
  type = string
  description = "Src api Target Group ARN"
}

variable "dashboard-tg-arn" {
  type = string
  description = "Dashboard API Target Group ARN"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private Subnet ID's"
}

variable "security_group" {
  type = string
  description = "Security group for ALB ID"
}