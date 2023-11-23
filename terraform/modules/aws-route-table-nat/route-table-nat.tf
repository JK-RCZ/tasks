# This module uses NAT as a target

# This module depends on Subnets, VPC and NAT(s).
# Please set respective dependensies in root module!

resource "aws_route_table" "this" {
  count                     = length(var.route_table_nat.nat_name)
  vpc_id                    = data.aws_vpc.data.id
  route {
    cidr_block              = var.route_table_nat.destination_cidr_block
    nat_gateway_id          = data.aws_nat_gateway.data[count.index].id
  }
  tags                      = merge(var.common_tags, {Name = "${var.route_table_nat.route_table_name[count.index]}"})
}

resource "aws_route_table_association" "this" {
  count                     = length(var.route_table_nat.private_subnet_name)
  subnet_id                 = data.aws_subnet.data[count.index].id
  route_table_id            = aws_route_table.this[count.index].id
}
