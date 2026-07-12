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
  vpc_id         = module.vpc.vpc_id
  acm-cert-arn   = module.acm.acm-cert-arn
}

module "ecs" {
  source                   = "./modules/ecs"
  src-tg-arn               = module.alb.src-tg-arn
  dashboard-tg-arn         = module.alb.dashboard-api-tg
  src_container_port       = var.src_container_port
  dashboard_container_port = var.dashboard_container_port
  ecs-service-role-arn     = module.iam.ecs-service-role-arn
  private_subnets          = module.vpc.private_subnets
  security_group           = module.security_group.alb_sg_id
}

module "iam" {
  source = "./modules/iam"
}

module "acm" {
  source             = "./modules/acm"
  domain_name        = var.domain_name
  cloudflare_zone_id = var.cloudflare_zone_id
}

module "waf" {
  source  = "./modules/waf"
  alb-arn = module.alb.alb-arn
}
