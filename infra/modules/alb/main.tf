resource "aws_lb" "url-alb" {
  name               = "url-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "src-api-tg" {
  name        = "src-api-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/dashboard"
    port                = "8080"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "dashboard-api-tg" {
  name        = "dashboard-api-tg"
  port        = 8081
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id


  health_check {
    enabled             = true
    path                = "/healthz"
    port                = "8081"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.url-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm-cert-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.src-api-tg.arn
  }
}


resource "aws_lb_listener_rule" "dashboard_routing" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard-api-tg.arn
  }

  condition {
    path_pattern {
      values = [
        "/summary*",
        "/top*",
        "recent*"
      ]
    }
  }
}


