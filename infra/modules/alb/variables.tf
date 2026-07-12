variable "alb_sg_id" {
  type        = string
  description = "ALB Security Group ID"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnet ID's"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "acm-cert-arn" {
  type = string
  description = "ACM Cert ARN"
}