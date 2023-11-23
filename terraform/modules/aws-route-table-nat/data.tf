
data "aws_nat_gateway" "data" {
  count                     = length(var.route_table_nat.nat_name)
  state                     = "available"
  tags                      = {
    Name                    = var.route_table_nat.nat_name[count.index]
  }
  
}

data "aws_subnet" "data" {
  count                     = length(var.route_table_nat.private_subnet_name)
  tags                      = {
    Name                    = var.route_table_nat.private_subnet_name[count.index]  }
}

data "aws_vpc" "data" {
  tags                      = {
    Name                    = var.route_table_nat.vpc_name
  }
}
