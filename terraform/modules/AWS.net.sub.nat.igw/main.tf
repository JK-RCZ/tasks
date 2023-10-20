provider "aws" {
   region = var.vpc_parameters.region

}


resource "aws_vpc" "major" {
  cidr_block                = var.vpc_parameters.vpc_cidr_block
  instance_tenancy          = "default"

  tags = merge(var.common_tags, {Name = "${var.vpc_parameters.vpc_name_tag}"})
 
}

resource "aws_subnet" "minor_private" {
  count = length(var.private_subnets)
  vpc_id                    = aws_vpc.major.id
  cidr_block                = var.private_subnets[count.index].cidr_block
  map_public_ip_on_launch   = "false"
  availability_zone         = var.private_subnets[count.index].availability_zone

  tags = merge(var.common_tags, {Name = "${var.private_subnets[count.index].name}"})
}

resource "aws_subnet" "minor_public" {
  count = length(var.public_subnets)
  vpc_id                    = aws_vpc.major.id
  cidr_block                = var.public_subnets[count.index].cidr_block
  map_public_ip_on_launch   = "true"
  availability_zone         = var.public_subnets[count.index].availability_zone

  tags = merge(var.common_tags, {Name = "${var.public_subnets[count.index].name}"})
}

resource "aws_internet_gateway" "sky" {
  vpc_id                    = aws_vpc.major.id
  tags = merge(var.common_tags, {Name = "${var.vpc_parameters.internnet_gw_name_tag}"})
}


resource "aws_eip" "nose" {
  count = length(var.private_subnets)
  domain                    = "vpc"
  associate_with_private_ip = var.private_subnets[count.index].cidr_block 
  depends_on                = [aws_internet_gateway.sky]
  tags = merge(var.common_tags, {Name = "${var.private_subnets[count.index].name} Elastic IP"})
  
}


resource "aws_nat_gateway" "one-way" {
  count = length(var.private_subnets)
  allocation_id             = aws_eip.nose[count.index].id
  subnet_id                 = aws_subnet.minor_private[count.index].id

  tags = merge(var.common_tags, {Name = "${var.private_subnets[count.index].name} NAT"})
  depends_on                = [aws_internet_gateway.sky]
}



resource "aws_route_table" "skynet" {
  vpc_id                    = aws_vpc.major.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.sky.id
  }
  tags = merge(var.common_tags, {Name = "${var.vpc_parameters.vpc_name_tag} Route Table"})
  depends_on                = [aws_internet_gateway.sky]
}

resource "aws_route_table" "skynet_private" {
  count = length(var.private_subnets)
  vpc_id                    = aws_vpc.major.id
  route {
    cidr_block              = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.one-way[count.index].id
  }
  tags = merge(var.common_tags, {Name = "${var.private_subnets[count.index].name} Route Table"})
  depends_on                = [aws_internet_gateway.sky]
}

resource "aws_route_table_association" "Cat-Skynet" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.minor_public[count.index].id
  route_table_id = aws_route_table.skynet.id
}
resource "aws_route_table_association" "Mouse-Skynet" {
  count = length(var.private_subnets)
  subnet_id = aws_subnet.minor_private[count.index].id
  route_table_id = aws_route_table.skynet_private[count.index].id
}





