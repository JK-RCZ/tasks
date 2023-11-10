#This module depends on subnets and NATs, please set respective dependensies in root module
#This module uses NAT as a target


data "aws_nat_gateway" "out" {
  count                     = length(var.nat_route_table_params.nat_name)
  state                     = "available"
  tags                      = {
    Name                    = var.nat_route_table_params.nat_name[count.index]
  }
  
}
resource "aws_route_table" "uno" {
  count                     = length(var.nat_route_table_params.nat_name)
  vpc_id                    = var.vpc_id
  route {
    cidr_block              = var.nat_route_table_params.destination_cidr_block
    nat_gateway_id          = data.aws_nat_gateway.out[count.index].id
  }
  tags                      = merge(var.common_tags, {Name = "${var.nat_route_table_params.route_table_name[count.index]}"})
}

data "aws_subnet" "subnet" {
  count                     = length(var.nat_route_table_params.private_subnet_name)
  tags                      = {
    Name                    = var.nat_route_table_params.private_subnet_name[count.index]  }
}

resource "aws_route_table_association" "duo" {
  count                     = length(var.nat_route_table_params.private_subnet_name)
  subnet_id                 = data.aws_subnet.subnet[count.index].id
  route_table_id            = aws_route_table.uno[count.index].id
}
