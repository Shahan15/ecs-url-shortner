resource "aws_lb" "url-alb" {
  name               = "test-lb-tf"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "ecs-task" {
  # ...
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.url-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "x"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-task.arn
  }
}

