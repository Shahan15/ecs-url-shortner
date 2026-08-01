variable "github_organisation_name" {
  type        = string
  description = "Github organisation name"
}

variable "db_secret_arn" {
  type        = string
  description = "Secrets Manager ARN"
  sensitive   = true
}