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
}
