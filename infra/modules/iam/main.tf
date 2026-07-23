resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "EcsServiceRole"
  }
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attach" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


#OIDC IAM Config
resource "aws_iam_openid_connect_provider" "github_openid" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com", ]
  thumbprint_list = ["fffffffffffffffffffffffffffffffffffffff"]
}


resource "aws_iam_role" "github-actions-role" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_openid.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_organisation_name}/*"
          }
        }
      }
    ]
  })

  tags = {
    tag-key = "GithubActionsRole"
  }
}

resource "aws_iam_role_policy_attachment" "github-role-attach" {
  role       = aws_iam_role.github-actions-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}