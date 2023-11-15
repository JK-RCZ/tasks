# This module depends on VPC.
# Please set respective dependensies in root module!

data "aws_vpc" "data" {
    tags                    = {
      Name                  = var.igw.vpc_name
    }
}

resource "aws_internet_gateway" "thing" {
  vpc_id                    = data.aws_vpc.data.id
  tags                      = merge(var.common_tags, {Name = "${var.igw.igw_name}"})
}