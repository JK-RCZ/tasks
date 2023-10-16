provider "aws" {
   region = var.vpc_parameters.region

}

locals {
  pub_subs = [
    for i in range(length(var.subnets)):
      var.subnets[i] if var.subnets[i].public == true
  ]
  priv_subs = [
    for i in range(length(var.subnets)):
      var.subnets[i] if var.subnets[i].public == false
  ]
  pub_sub_index = [
    for i in range(length(var.subnets)):
      i if var.subnets[i].public == true
  ]

  priv_sub_index = [
    for i in range(length(var.subnets)):
      i if var.subnets[i].public == false
  ]
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


resource "aws_internet_gateway" "sky" {
  vpc_id                    = aws_vpc.major.id
  tags = merge(var.common_tags, {Name = "${var.vpc_parameters.internnet_gw_name_tag}"})
}


resource "aws_eip" "nose" {
  count = length(local.pub_subs)
  domain                    = "vpc"
  associate_with_private_ip = local.pub_subs[count.index].cidr_block 
  depends_on                = [aws_internet_gateway.sky]
  tags = merge(var.common_tags, {Name = "${local.pub_subs[count.index].name} Elastic IP"})
  
}


resource "aws_nat_gateway" "one-way" {
  count = length(local.pub_subs)
  allocation_id             = aws_eip.nose[count.index].id
  subnet_id                 = aws_subnet.minor[local.pub_sub_index[count.index]].id

  tags = merge(var.common_tags, {Name = "${local.pub_subs[count.index].name} NAT"})
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
  count = length(local.pub_sub_index)
  vpc_id                    = aws_vpc.major.id
  route {
    cidr_block              = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.one-way[count.index].id
  }
  tags = merge(var.common_tags, {Name = "${local.priv_subs[count.index].name} Route Table"})
  depends_on                = [aws_internet_gateway.sky]
}

resource "aws_route_table_association" "Cat-Skynet" {
  count = length(local.pub_sub_index)
  subnet_id = aws_subnet.minor[local.pub_sub_index[count.index]].id
  route_table_id = aws_route_table.skynet.id
}
resource "aws_route_table_association" "Mouse-Skynet" {
  count = length(local.priv_sub_index)
  subnet_id = aws_subnet.minor[local.priv_sub_index[count.index]].id
  route_table_id = aws_route_table.skynet_private[count.index].id
}





