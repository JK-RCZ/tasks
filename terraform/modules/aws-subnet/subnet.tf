
resource "aws_subnet" "thing" {
    count                     = length(var.subnets)
    vpc_id                    = var.vpc_id
    cidr_block                = var.subnets[count.index].cidr_block
    map_public_ip_on_launch   = var.subnets[count.index].map_public_ip_on_launch
    availability_zone         = var.subnets[count.index].availability_zone

    tags                      = var.subnets[count.index].map_public_ip_on_launch ? merge(var.common_tags, {Name = "${var.subnets[count.index].name}"}, {Type = "public"}) : merge(var.common_tags, {Name = "${var.subnets[count.index].name}"}, {Type = "private"}) 
}
