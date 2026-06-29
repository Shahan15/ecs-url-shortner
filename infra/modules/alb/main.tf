resource "aws_lb" "url-alb" {
  name               = "test-lb-tf"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
}



