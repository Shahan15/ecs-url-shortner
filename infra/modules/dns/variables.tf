variable "name_servers_map" {
  type = map(string)
  description = "Map of static keys to dynamic Route 53 Name Servers"
}

variable "cloudflare_zone_id" {
  type = string
  description = "CloudFlare Zone ID"
}

variable "sub_domain" {
  type = string
  description = "Sub Domain name"
}