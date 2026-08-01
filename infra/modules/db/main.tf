resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "postgres" {
  identifier             = "url-shortener-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  db_name                = "urlshortener"
  username               = "dbadmin"
  password               = random_password.db_password.result
  db_subnet_group_name   = var.db_subnet_name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot    = true
}

resource "aws_secretsmanager_secret" "db_connection_string" {
  name                    = "url-shortener-db-connection-string"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_connection_string_version" {
  secret_id = aws_secretsmanager_secret.db_connection_string.id
  secret_string = jsonencode({
    database_url = "postgresql://${aws_db_instance.postgres.username}:${urlencode(random_password.db_password.result)}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}"
  })
}
