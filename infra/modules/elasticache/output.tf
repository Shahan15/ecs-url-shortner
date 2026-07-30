output "redis_endpoint" {
  value       = aws_elasticache_cluster.lnk-elasticache.cache_nodes[0].address
  description = "Redis endpoint name"
}

output "redis_port" {
  value       = aws_elasticache_cluster.lnk-elasticache.cache_nodes[0].port
  description = "Redis port"
}