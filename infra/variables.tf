variable "src_container_port" {
  type        = number
  description = "Internal port for the FastAPI core application"
}

variable "dashboard_container_port" {
  type        = number
  description = "Internal port for the Go dashboard application"
}

variable "domain_name" {
  type        = string
  description = "Domain Name"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare Account API Token"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
  sensitive = true
}