
data "aws_ecr_repository" "url-shortner-ecr" {
  name = "url-shortner"
}

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
        ]
    }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
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
    security_groups  = [var.security_group]
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
        ]
    }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "url-dashboard-ecs-service" {
  name            = "url-short-dashboard-ecs-service"
  cluster         = aws_ecs_cluster.url-short-ecs-cluster.id
  task_definition = aws_ecs_task_definition.url-dashboard-td.id
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.dashboard-tg-arn
    container_name   = "url-dashboard-container"
    container_port   = var.dashboard_container_port
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.security_group]
    assign_public_ip = false
  }

}


