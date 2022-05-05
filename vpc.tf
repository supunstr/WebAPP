#vpc resource
resource "aws_vpc" "vpc-mAgri" {

  cidr_block = var.vpccidr
  tags = {
    Name = "VPC-MAGRI"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw-magri" {

  vpc_id = aws_vpc.vpc-mAgri.id
  tags = {
    Name = "IGW-MAGRI"
  }
}

#Public Subnet 1
resource "aws_subnet" "pubsub01" {
  cidr_block              = var.pubsub01cidr
  vpc_id                  = aws_vpc.vpc-mAgri.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "PUBLICSUB01-MAGRI"
  }
}

#Public Subnet 2
resource "aws_subnet" "pubsub02" {
  cidr_block              = var.pubsub02cidr
  vpc_id                  = aws_vpc.vpc-mAgri.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "PUBLICSUB02-MAGRI"
  }
}

#Private Subnet 1
resource "aws_subnet" "prisub01" {
  cidr_block              = var.prisub01cidr
  vpc_id                  = aws_vpc.vpc-mAgri.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "PRISUB01-MAGRI"
  }
}

#Private Subnet 2
resource "aws_subnet" "prisub02" {
  cidr_block              = var.prisub02cidr
  vpc_id                  = aws_vpc.vpc-mAgri.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "PRISUB02-MAGRI"
  }
}

#Public Route Table
resource "aws_route_table" "routetablepublic" {
  vpc_id = aws_vpc.vpc-mAgri.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-magri.id
  }
  tags = {
    Name = "RT-PUBRT-MAGRI"
  }
}

#Associate Public Route Table to Public Subnets
resource "aws_route_table_association" "pubrtas1" {
  subnet_id      = aws_subnet.pubsub01.id
  route_table_id = aws_route_table.routetablepublic.id
}

resource "aws_route_table_association" "pubrtas2" {
  subnet_id      = aws_subnet.pubsub02.id
  route_table_id = aws_route_table.routetablepublic.id
}