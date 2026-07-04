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
