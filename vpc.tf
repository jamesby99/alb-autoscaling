# Declare the data source
data "aws_availability_zones" "available" {
  state    = "available"
}

locals {
  zone_count = length(data.aws_availability_zones.available.names)
}

# Internet VPC
resource "aws_vpc" "user11-vpc" {
  cidr_block           = "11.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "user11-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "user11-public" {
  vpc_id                  = aws_vpc.user11-vpc.id
  count                   = var.PUBLIC_SUBNET_NUMBERS
  cidr_block              = cidrsubnet(aws_vpc.user11-vpc.cidr_block, 8, count.index+1)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[(count.index%local.zone_count)]

  tags = {
    Name = "user11-public-subnet"
  }
}


# Internet GW
resource "aws_internet_gateway" "user11-igw" {
  vpc_id = aws_vpc.user11-vpc.id

  tags = {
    Name = "user11-igw"
  }
}

# route tables
resource "aws_route_table" "user11-public-route" {
  vpc_id = aws_vpc.user11-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.user11-igw.id
  }

  tags = {
    Name = "user11-public-route"
  }
}

# route associations public
resource "aws_route_table_association" "user11-public" {
  count          = length(aws_subnet.user11-public)
  subnet_id      = aws_subnet.user11-public[count.index].id
  route_table_id = aws_route_table.user11-public-route.id
}
