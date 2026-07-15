output "vpc_id" {
  value       = aws_vpc.url-vpc.id
  description = "VPC ID"
}

output "public_subnets" {
  value       = aws_subnet.public-subnet[*].id
  description = "Public Subnet ID's"
}

output "private_subnets" {
  value       = aws_subnet.private-subnet[*].id
  description = "Public Subnet ID's"
}

output "db_subnet_name" {
  value       = aws_db_subnet_group.db_subnet.name
  description = "DB Subnet name"
}
