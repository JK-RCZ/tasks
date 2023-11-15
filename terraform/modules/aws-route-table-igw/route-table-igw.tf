# This module uses internet gateway as a target

# This module depends on Subnets, VPC and Internet Gateway.
# Please set respective dependensies in root module!


data "aws_internet_gateway" "out" {
  tags                      = {
    Name                    = var.route_table_igw.igw_name
  }
  
}

data "aws_subnet" "subnet" {
  count                     = length(var.route_table_igw.subnet_name)
  tags                      = {
    Name                    = var.route_table_igw.subnet_name[count.index]  }
}

data "aws_vpc" "data" {
    tags                    = {
      Name                  = var.route_table_igw.vpc_name
    }
}

resource "aws_route_table" "uno" {
  vpc_id                    = data.aws_vpc.data.id
  route {
    cidr_block              = var.route_table_igw.destination_cidr_block
    gateway_id              = data.aws_internet_gateway.out.id
  }
  tags                      = merge(var.common_tags, {Name = "${var.route_table_igw.name}"})
}

resource "aws_route_table_association" "duo" {
  count                     = length(var.route_table_igw.subnet_name)
  subnet_id                 = data.aws_subnet.subnet[count.index].id
  route_table_id            = aws_route_table.uno.id
}
