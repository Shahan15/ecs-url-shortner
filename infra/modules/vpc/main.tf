data "aws_availability_zones" "az_s" {
  state = "available"
}

resource "aws_vpc" "url-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "url-internet-gateway" {
  vpc_id = aws_vpc.url-vpc.id
}

# PUBLIC SUBNETS 
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.url-vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.az_s.names, count.index)
  count             = 2

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# PRIVATE SUBNETS
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.url-vpc.id
  cidr_block        = "10.0.${count.index + 3}.0/24"
  availability_zone = element(data.aws_availability_zones.az_s.names, count.index)
  count             = 2

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# ROUTE TABLES
# PUBLIC ROUTE
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.url-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.url-internet-gateway.id
  }
}

# PRIVATE ROUTE
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.url-vpc.id
}

# ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private_route.id
}

# ==========================================
# VPC ENDPOINTS
# ==========================================

# 1. ECR API Endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.url-vpc.id
  service_name        = "com.amazonaws.eu-west-1.ecr.api" 
  vpc_endpoint_type   = "Interface" 
  security_group_ids  = [var.vpc_endpoints_sg]
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private-subnet[*].id 
}

# 2. ECR Docker Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.url-vpc.id
  service_name        = "com.amazonaws.eu-west-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [var.vpc_endpoints_sg]
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private-subnet[*].id 
}

# 3. S3 Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.url-vpc.id
  service_name      = "com.amazonaws.eu-west-1.s3"
  vpc_endpoint_type = "Gateway"
  
  route_table_ids   = [aws_route_table.private_route.id]
}