
data "aws_ecr_repository" "url-shortner-ecr" {
  name = "url-shortner"
}


resource "aws_ecs_cluster" "url-short-ecs-cluster" {
  name = "url-short-ecs-cluster"
}

# ECS SERVICE FOR SRC CONTAINER - FRONTEND/FASTAPI
resource "aws_ecs_task_definition" "url-src-td" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "iis",
    "image": ${data.aws_ecr_repository.url-shortner-ecr.repository_url}:src-latest,
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings" : [
          {
            "containerPort" : ${var.src_container_port},
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
  name            = "url-short-ecs-service"
  cluster         = aws_ecs_cluster.url-short-ecs-cluster.id
  task_definition = aws_ecs_task_definition.url-src-td.id
  desired_count   = 2
  iam_role        = var.ecs-iam-role
#   depends_on      = [aws_iam_role_policy.foo]
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.alb-target_group_arn
    container_name   = "src-app"
    container_port   = var.src_container_port
  }

}
