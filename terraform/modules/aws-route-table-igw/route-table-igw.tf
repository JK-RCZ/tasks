#This module depends on subnets, please set respective dependensies in root module
#This module uses internet gateway as a target

resource "aws_route_table" "uno" {
  vpc_id                    = var.vpc_id
  route {
    cidr_block              = var.igw_route_table_params.destination_cidr_block
    gateway_id              = var.route_table_target_id
  }
  tags                      = merge(var.common_tags, {Name = "${var.igw_route_table_params.name}"})
}

data "aws_subnet" "subnet" {
  count                     = length(var.igw_route_table_params.subnet_name)
  tags                      = {
    Name                    = var.igw_route_table_params.subnet_name[count.index]  }
}

resource "aws_route_table_association" "Cat-Skynet" {
  count                     = length(var.igw_route_table_params.subnet_name)
  subnet_id                 = data.aws_subnet.subnet[count.index].id
  route_table_id            = aws_route_table.uno.id
}
