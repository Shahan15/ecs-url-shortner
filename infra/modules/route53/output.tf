output "hosted_zone_ns" {
  value       = aws_route53_zone.hosted_zone.name_servers
  description = "Hosted Zone Name Servers"
}