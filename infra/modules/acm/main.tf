resource "aws_acm_certificate" "url-short-acm-cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


# Automatically Updates CloudFlare DNS Records for ACM validation
resource "cloudflare_dns_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.url-short-acm-cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      content = dvo.resource_record_value
      type    = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = 60
  proxied = false
}

# Tells AWS to wait until Cloudflare propagates the records
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.url-short-acm-cert.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.acm_validation : record.name]
}
