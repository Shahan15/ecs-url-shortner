output "src-tg-arn" {
  value = aws_lb_target_group.src-api-tg.arn
  description = "Src API TG ARN"
}

output "dashboard-api-tg" {
  value = aws_lb_target_group.dashboard-api-tg.arn
  description = "Dashboard API TG ARN"
}