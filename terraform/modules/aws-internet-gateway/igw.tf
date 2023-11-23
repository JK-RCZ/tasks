# This module depends on VPC.
# Please set respective dependensies in root module!

resource "aws_internet_gateway" "this" {
  vpc_id                    = data.aws_vpc.data.id
  tags                      = merge(var.common_tags, {Name = "${var.igw.igw_name}"})
}