#vpc resource
resource "aws_vpc" "vpc-app" {

  cidr_block = var.vpccidr
  #cidr_block = "172.29.220.0/24"
  tags = {
    Name        = "VPC-APP"
    Environment = "app"
    Terraform   = "true"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw-app" {

  vpc_id = aws_vpc.vpc-app.id
  tags = {
    Name        = "IGW-APP"
    Environment = "app"
    Terraform   = "true"
  }
}

#Public Subnet 1
resource "aws_subnet" "pubsub01" {
  cidr_block              = var.pubsub01cidr
  vpc_id                  = aws_vpc.vpc-app.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name        = "PUBLICSUB01-APP"
    Environment = "app"
    Terraform   = "true"
  }
}

#Public Subnet 2
resource "aws_subnet" "pubsub02" {
  cidr_block              = var.pubsub02cidr
  vpc_id                  = aws_vpc.vpc-app.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name        = "PUBLICSUB02-APP"
    Environment = "app"
    Terraform   = "true"
  }
}

#Private Subnet 1
resource "aws_subnet" "prisub01" {
  cidr_block              = var.prisub01cidr
  vpc_id                  = aws_vpc.vpc-mAgri.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name        = "PRISUB01-MAGRI"
    Environment = "magri"
    Terraform   = "true"
  }
}

#Private Subnet 2
resource "aws_subnet" "prisub02" {
  cidr_block              = var.prisub02cidr
  vpc_id                  = aws_vpc.vpc-mAgri.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name        = "PRISUB02-MAGRI"
    Environment = "magri"
    Terraform   = "true"
  }
}

#Public Route Table
resource "aws_route_table" "routetablepublic" {
  vpc_id = aws_vpc.vpc-mAgri.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-magri.id
  }
  route {
    cidr_block                = "10.3.0.0/16"
    vpc_peering_connection_id = "pcx-01008ad3dba093089"
  }
  route {
    cidr_block                = "10.0.0.0/16"
    vpc_peering_connection_id = "pcx-02d3928fa276c2e12"
  }

  tags = {
    Name        = "RT-PUBRT-MAGRI"
    Environment = "magri"
    Terraform   = "true"
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
