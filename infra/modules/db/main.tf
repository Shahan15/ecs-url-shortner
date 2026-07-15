resource "aws_db_instance" "postgres" {
  identifier             = "url-shortener-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  db_name                = "urlshortener"
  username               = "dbadmin"
  password               = "securePassword!" # Will add a secrets manager later
  db_subnet_group_name   = var.db_subnet_name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot    = true
}


