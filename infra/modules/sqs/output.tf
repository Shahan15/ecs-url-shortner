output "sqs_url" {
  value = aws_sqs_queue.sqs_queue.url
  description = "SQL URL"
}