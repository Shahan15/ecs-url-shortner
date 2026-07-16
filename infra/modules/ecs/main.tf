
data "aws_ecr_repository" "url-shortner-ecr" {
  name = "url-shortner"
}

# resource "aws_cloudwatch_log_group" "ecs_dashboard_log_group" {
#   name              = "/ecs/url-short-dashboard"
#   retention_in_days = 7
# }

resource "aws_ecs_cluster" "url-short-ecs-cluster" {
  name = "url-short-ecs-cluster"
}

# ECS SERVICE FOR SRC CONTAINER - FRONTEND/FASTAPI API
resource "aws_ecs_task_definition" "url-src-td" {
  family                   = "url-src-td"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs-service-role-arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "url-src-container",
    "image": "${data.aws_ecr_repository.url-shortner-ecr.repository_url}:src-latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings" : [
          {
            "containerPort" : ${var.src_container_port}
          }
        ],
        "environment": [
      {
        "name": "DATABASE_URL",
        "value": "postgres://${var.db_username}:${var.db_password}@${var.db_endpoint}/${var.db_name}"
      },
      {
        "name": "PORT",
        "value": "${var.src_container_port}"
      }
    ]
    }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_ecs_service" "url-src-ecs-service" {
  name            = "url-short-src-ecs-service"
  cluster         = aws_ecs_cluster.url-short-ecs-cluster.id
  task_definition = aws_ecs_task_definition.url-src-td.id
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.src-tg-arn
    container_name   = "url-src-container"
    container_port   = var.src_container_port
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_src_sg_id]
    assign_public_ip = false
  }

}


#ECS SERVICE FOR DASHBOARD SERVICE API
resource "aws_ecs_task_definition" "url-dashboard-td" {
  family                   = "url-dashboard-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs-service-role-arn
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "url-dashboard-container",
    "image": "${data.aws_ecr_repository.url-shortner-ecr.repository_url}:dashboard-latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings" : [
      {
        "containerPort" : ${var.dashboard_container_port}
      }
    ],
    "environment": [
      {
        "name": "DATABASE_URL",
        "value": "postgres://${var.db_username}:${var.db_password}@${var.db_endpoint}/${var.db_name}"
      },
      {
        "name": "PORT",
        "value": "${var.dashboard_container_port}"
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_ecs_service" "url-dashboard-ecs-service" {
  name            = "url-short-dashboard-ecs-service"
  cluster         = aws_ecs_cluster.url-short-ecs-cluster.id
  task_definition = aws_ecs_task_definition.url-dashboard-td.id
  desired_count   = 1
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 60

  load_balancer {
    target_group_arn = var.dashboard-tg-arn
    container_name   = "url-dashboard-container"
    container_port   = var.dashboard_container_port
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_dashboard_sg_id]
    assign_public_ip = false
  }

}

# ECS Service for Worker/Click analytics
resource "aws_ecs_task_definition" "url-worker-td" {
  family                   = "url-worker-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs-service-role-arn
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "url-worker-container",
    "image": "${data.aws_ecr_repository.url-shortner-ecr.repository_url}:worker-latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
        "environment": [
      {
        "name": "DATABASE_URL",
        "value": "postgres://${var.db_username}:${var.db_password}@${var.db_endpoint}/${var.db_name}"
      },
      {
        "name": "SQS_QUEUE_URL",
        "value": "${var.sqs_url}"
      }
    ]
    }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_ecs_service" "url-worker-ecs-service" {
  name            = "url-short-worker-ecs-service"
  cluster         = aws_ecs_cluster.url-short-ecs-cluster.id
  task_definition = aws_ecs_task_definition.url-worker-td.id
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_worker_sg_id]
    assign_public_ip = false
  }

}


