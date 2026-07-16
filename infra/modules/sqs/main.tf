resource "aws_sqs_queue" "sqs_queue" {
  name                      = "sqs_queue"
  delay_seconds             = 30
  max_message_size          = 1024
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_queue_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "sqs_queue_deadletter" {
  name                      = "sqs_queue_deadletter"
  message_retention_seconds = 1209600 
}