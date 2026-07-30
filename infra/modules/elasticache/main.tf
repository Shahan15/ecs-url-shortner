resource "aws_elasticache_cluster" "lnk-elasticache" {
  cluster_id           = "lnk-elasticache"
  engine               = "redis"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
  subnet_group_name    = var.elasticache_subnet_group_name
  security_group_ids   = [var.redis_sg_id]
}