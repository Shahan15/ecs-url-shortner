module "vpc" {
  source           = "./modules/vpc"
  vpc_endpoints_sg = module.security_group.vpc_endpoints_sg
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
  ecs_src_sg_id            = module.security_group.ecs_src_sg_id
  ecs_dashboard_sg_id      = module.security_group.ecs_dashboard_sg_id
  ecs_worker_sg_id         = module.security_group.ecs_worker_sg_id
  db_username              = module.db.db_name
  db_endpoint              = module.db.db_endpoint
  db_name                  = module.db.db_name
  db_password              = module.db.db_password
  sqs_url                  = module.sqs.sqs_url
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

module "route53" {
  source       = "./modules/route53"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "dns" {
  source             = "./modules/dns"
  cloudflare_zone_id = var.cloudflare_zone_id
  sub_domain         = var.sub_domain
  name_servers_map = {
    "ns0" = module.route53.hosted_zone_ns[0]
    "ns1" = module.route53.hosted_zone_ns[1]
    "ns2" = module.route53.hosted_zone_ns[2]
    "ns3" = module.route53.hosted_zone_ns[3]
  }
}

module "db" {
  source         = "./modules/db"
  db_sg_id       = module.security_group.db_sg_id
  db_subnet_name = module.vpc.db_subnet_name
}

module "sqs" {
  source = "./modules/sqs"
}
