# This module uses internet gateway as a target

# This module depends on Subnets, VPC and Internet Gateway.
# Please set respective dependensies in root module!

resource "aws_route_table" "this" {
  vpc_id                    = data.aws_vpc.vpc_id.id
  route {
    cidr_block              = var.route_table_igw.destination_cidr_block
    gateway_id              = data.aws_internet_gateway.gateway_id.id
  }
  tags                      = merge(var.common_tags, {Name = "${var.route_table_igw.name}"})
}

resource "aws_route_table_association" "this" {
  count                     = length(var.route_table_igw.subnet_name)
  subnet_id                 = data.aws_subnet.subnet_id[count.index].id
  route_table_id            = aws_route_table.this.id
}
