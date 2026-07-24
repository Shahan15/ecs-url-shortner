output "ecs-service-role-arn" {
  value       = aws_iam_role.ecs-service-role.arn
  description = "ECS Task Execution Role for Fargate"
}

output "github-actions-role" {
  value       = aws_iam_role.github-actions-role.arn
  description = "IAM Role for github actions"
}

output "ecs-task-app-role-arn" {
  value       = aws_iam_role.ecs-task-app-role.arn
  description = "ECS Task role for SQS"
}
