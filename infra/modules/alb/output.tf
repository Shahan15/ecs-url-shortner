output "src-tg-arn" {
  value = aws_lb_target_group.src-api-tg.arn
  description = "Src API TG ARN"
}

output "dashboard-api-tg" {
  value = aws_lb_target_group.dashboard-api-tg.arn
  description = "Dashboard API TG ARN"
}

output "alb-arn" {
  value = aws_lb.url-alb.arn
  description = "ALB URN"
}

output "alb_dns_name" {
  value = aws_lb.url-alb.dns_name
  description = "DNS Name of the ALB"
}

output "alb_zone_id" {
  value = aws_lb.url-alb.zone_id
  description = "The zone id of the ALB"
}