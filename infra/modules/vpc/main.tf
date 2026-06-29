data "aws_availability_zones" "az_s" {
  state = "available"
}

resource "aws_vpc" "url-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

#INTERNET GATEWAY
resource "aws_internet_gateway" "url-internet-gateway" {
  vpc_id = aws_vpc.url-vpc.id
}


#PUBLIC SUBNETS 
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.url-vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.az_s.names, count.index)
  count             = 2

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}


#PRIVATE SUBNETS
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.url-vpc.id
  cidr_block        = "10.0.${count.index + 3}.0/24"
  availability_zone = element(data.aws_availability_zones.az_s.names, count.index)
  count             = 2

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

#ROUTE TABLES
#PUBLIC ROUTE
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.url-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.url-internet-gateway.id
  }
}

#PRIVATE ROUTE
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.url-vpc.id

}


#ROUTE TABLE ASSOCIATION
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
