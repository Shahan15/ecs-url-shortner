resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS SERVICE FOR SRC CONTAINER (FASTAPI API)
resource "aws_security_group" "ecs_src_sg" {
  name        = "ecs_src_sg"
  description = "Security Group for ECS to only allow traffic from ALB for dashboard API"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS SERVICE FOR DASHBOARD SERVICE API
resource "aws_security_group" "ecs_dashboard_sg" {
  name        = "ecs_dashboard_sg"
  description = "Security Group for ECS to only allow traffic from ALB for dashboard API"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS SERVICE FOR WORKER SERVICE 
resource "aws_security_group" "ecs_worker_sg" {
  name        = "ecs_worker_sg"
  description = "Security Group for ECS to only allow traffic from ALB for worker API"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Dedicated Security Group for VPC Endpoints
resource "aws_security_group" "vpc_endpoints_sg" {
  name        = "vpc_endpoints_sg"
  description = "Allow private ECS tasks to communicate with VPC Endpoints"
  vpc_id      = var.vpc_id

  # Allow inbound HTTPS (443) ONLY from ECS task security groups
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    security_groups = [
      aws_security_group.ecs_src_sg.id,
      aws_security_group.ecs_dashboard_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Dedicated Security Group for RDS Postgres
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow inbound traffic to RDS from ECS Tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [
      aws_security_group.ecs_src_sg.id,
      aws_security_group.ecs_dashboard_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


