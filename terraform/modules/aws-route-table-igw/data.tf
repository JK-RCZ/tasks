
data "aws_internet_gateway" "gateway_id" {
  tags                      = {
    Name                    = var.route_table_igw.igw_name
  }
}

data "aws_subnet" "subnet_id" {
  count                     = length(var.route_table_igw.subnet_name)
  tags                      = {
    Name                    = var.route_table_igw.subnet_name[count.index]  }
}

data "aws_vpc" "vpc_id" {
    tags                    = {
      Name                  = var.route_table_igw.vpc_name
    }
}