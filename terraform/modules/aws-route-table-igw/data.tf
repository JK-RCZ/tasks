
data "aws_internet_gateway" "data" {
  tags                      = {
    Name                    = var.route_table_igw.igw_name
  }
}

data "aws_subnet" "data" {
  count                     = length(var.route_table_igw.subnet_name)
  tags                      = {
    Name                    = var.route_table_igw.subnet_name[count.index]  }
}

data "aws_vpc" "data" {
    tags                    = {
      Name                  = var.route_table_igw.vpc_name
    }
}