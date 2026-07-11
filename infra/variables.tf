variable "src_container_port" {
  type        = number # Changed from string
  description = "Internal port for the FastAPI core application"
}

variable "dashboard_container_port" {
  type        = number # Changed from string
  description = "Internal port for the Go dashboard application"
}
