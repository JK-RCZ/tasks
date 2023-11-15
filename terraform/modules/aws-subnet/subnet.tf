# This module depends on VPC.
# Please set respective dependensies in root module!

data "aws_vpc" "data" {
    tags                      = {
      Name                    = var.subnets.vpc_name
    }
}

resource "aws_subnet" "thing" {
    count                     = length(var.subnets.subnets_params)
    vpc_id                    = data.aws_vpc.data.id
    cidr_block                = var.subnets.subnets_params[count.index].cidr_block
    map_public_ip_on_launch   = var.subnets.subnets_params[count.index].map_public_ip_on_launch
    availability_zone         = var.subnets.subnets_params[count.index].availability_zone

    tags                      = var.subnets.subnets_params[count.index].map_public_ip_on_launch ? merge(var.common_tags, {Name = "${var.subnets.subnets_params[count.index].name}"}, {Type = "public"}) : merge(var.common_tags, {Name = "${var.subnets.subnets_params[count.index].name}"}, {Type = "private"}) 
}
