module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source         = "./modules/alb"
  alb_sg_id      = module.security_group.alb_sg_id
  public_subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
}

module "ecs" {
  source = "./modules/ecs"
  src-tg-arn= module.alb.src-tg-arn
  dashboard-tg-arn = module.alb.dashboard-api-tg
  src_container_port = var.src_container_port
  dashboard_container_port = var.dashboard_container_port
  ecs-service-role-arn = module.iam.ecs-service-role-arn
}

module "iam" {
  source = "./modules/iam"
}