variable "src_container_port" {
  type        = number
  default     = 8080
  description = "Internal port for the FastAPI core application"
}

variable "dashboard_container_port" {
  type        = number
  default     = 8081
  description = "Internal port for the Go dashboard application"
}

variable "domain_name" {
  type        = string
  description = "Domain Name"
}

variable "sub_domain" {
  type        = string
  description = "Sub Domain"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare Account API Token"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
  default     = "9f1d70625cc7807b75c8e6820e326cb3"
}

variable "github_organisation_name" {
  type        = string
  description = "Github organisation name"
}