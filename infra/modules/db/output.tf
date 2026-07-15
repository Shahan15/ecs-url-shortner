output "db_username" {
  value = aws_db_instance.postgres.username
  description = "The username for the database"
}

output "db_password" {
  value       = aws_db_instance.postgres.password
  description = "The password for the database"
  sensitive   = true
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
  description = "The connection endpoint for the database (host:port)"
}

output "db_name" {
  value = aws_db_instance.postgres.db_name
  description = "The default database name"
}
