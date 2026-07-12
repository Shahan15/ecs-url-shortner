resource "cloudflare_dns_record" "acm_validation" {
  for_each = var.name_servers_map

  zone_id = var.cloudflare_zone_id
  name    = var.sub_domain
  content = each.value
  type    = "NS"
  ttl     = 86400
  proxied = false
}