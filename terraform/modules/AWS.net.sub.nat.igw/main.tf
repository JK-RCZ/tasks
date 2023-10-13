provider "aws" {
   region = var.vpc_parameters.region

}
resource "aws_vpc" "major" {
  cidr_block                = var.vpc_parameters.vpc_cidr_block
  instance_tenancy          = "default"

  tags = merge(var.common_tags, {Name = "${var.vpc_parameters.vpc_name_tag}"})
 
}

resource "aws_subnet" "minor" {
  count = length(var.subnets)
  vpc_id                    = aws_vpc.major.id
  cidr_block                = var.subnets[count.index].cidr_block
  map_public_ip_on_launch   = var.subnets[count.index].public
  availability_zone         = var.subnets[count.index].availability_zone

  tags = merge(var.common_tags, {Name = "${var.subnets[count.index].name}"})
}

/*
#------------------------------------ CREATING INTERNET GATEWAY ---------------------------------
resource "aws_internet_gateway" "terra-dev-env-igw" {
  vpc_id                    = aws_vpc.terra-dev-env-net.id
  tags = {
    Name                    = "terra-dev-env-igw"
  }
}

#--------------------------------------- CREATING ELASTIC IP'S ------------------------------------
resource "aws_eip" "terra-env-dev-eli-1" {
  domain                    = "vpc"
  associate_with_private_ip = "10.0.0.0"
  depends_on                = [aws_internet_gateway.terra-dev-env-igw]
}
resource "aws_eip" "terra-env-dev-eli-2" {
  domain                    = "vpc"
  associate_with_private_ip = "10.0.128.0"
  depends_on                = [aws_internet_gateway.terra-dev-env-igw]
}

#------------------------------------------- CREATING NATS ----------------------------------------
resource "aws_nat_gateway" "terra-env-dev-nat1" {
  allocation_id             = aws_eip.terra-env-dev-eli-1.id
  subnet_id                 = aws_subnet.terra-dev-env-public1-subnet.id

  tags = {
    Name = "terra-env-dev-nat1"
  }
  depends_on                = [aws_internet_gateway.terra-dev-env-igw]
}
resource "aws_nat_gateway" "terra-env-dev-nat2" {
  allocation_id             = aws_eip.terra-env-dev-eli-2.id
  subnet_id                 = aws_subnet.terra-dev-env-public2-subnet.id

  tags = {
    Name = "terra-env-dev-nat2"
  }
  depends_on                = [aws_internet_gateway.terra-dev-env-igw]
}


#---------------------------------------- CREATING ROUTE TABLE -------------------------------------
resource "aws_route_table" "terra-dev-env-public-route-table" {
  vpc_id                    = aws_vpc.terra-dev-env-net.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.terra-dev-env-igw.id
  }
  tags = {
    Name                    = "task-route-table"
  }
}

resource "aws_route_table" "terra-dev-env-private1-route-table" {
  vpc_id                    = aws_vpc.terra-dev-env-net.id
  route {
    cidr_block              = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.terra-env-dev-nat1.id
  }
  tags = {
    Name                    = "terra-dev-env-private1-route-table"
  }
}

resource "aws_route_table" "terra-dev-env-private2-route-table" {
  vpc_id                    = aws_vpc.terra-dev-env-net.id
  route {
    cidr_block              = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.terra-env-dev-nat2.id
  }
  tags = {
    Name                    = "terra-dev-env-private2-route-table"
  }
}

resource "aws_route_table_association" "terra-dev-env-private1-association" {
  subnet_id                 = aws_subnet.terra-dev-env-private1-subnet.id
  route_table_id            = aws_route_table.terra-dev-env-private1-route-table.id
}

resource "aws_route_table_association" "terra-dev-env-private2-association" {
  subnet_id                 = aws_subnet.terra-dev-env-private2-subnet.id
  route_table_id            = aws_route_table.terra-dev-env-private2-route-table.id
}

resource "aws_route_table_association" "terra-dev-env-public1-association" {
  subnet_id                 = aws_subnet.terra-dev-env-public1-subnet.id
  route_table_id            = aws_route_table.terra-dev-env-public-route-table.id
}
resource "aws_route_table_association" "terra-dev-env-public2-association" {
  subnet_id                 = aws_subnet.terra-dev-env-public2-subnet.id
  route_table_id            = aws_route_table.terra-dev-env-public-route-table.id
}
*/