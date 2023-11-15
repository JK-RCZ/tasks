# This module uses NAT as a target

# This module depends on Subnets, VPC and NAT(s).
# Please set respective dependensies in root module!


data "aws_nat_gateway" "out" {
  count                     = length(var.route_table_nat.nat_name)
  state                     = "available"
  tags                      = {
    Name                    = var.route_table_nat.nat_name[count.index]
  }
  
}

data "aws_subnet" "subnet" {
  count                     = length(var.route_table_nat.private_subnet_name)
  tags                      = {
    Name                    = var.route_table_nat.private_subnet_name[count.index]  }
}

data "aws_vpc" "data" {
  tags                      = {
    Name                    = var.route_table_nat.vpc_name
  }
}

resource "aws_route_table" "uno" {
  count                     = length(var.route_table_nat.nat_name)
  vpc_id                    = data.aws_vpc.data.id
  route {
    cidr_block              = var.route_table_nat.destination_cidr_block
    nat_gateway_id          = data.aws_nat_gateway.out[count.index].id
  }
  tags                      = merge(var.common_tags, {Name = "${var.route_table_nat.route_table_name[count.index]}"})
}

resource "aws_route_table_association" "duo" {
  count                     = length(var.route_table_nat.private_subnet_name)
  subnet_id                 = data.aws_subnet.subnet[count.index].id
  route_table_id            = aws_route_table.uno[count.index].id
}
