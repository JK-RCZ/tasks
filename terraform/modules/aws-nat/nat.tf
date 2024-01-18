# This module depends on Subnets.
# Please set respective dependensies in root module!

resource "aws_eip" "this" {
  count = length(var.nat.private_subnet_name)
  domain                    = var.nat.domain
  associate_with_private_ip = data.aws_subnet.private[count.index].cidr_block 
  
  tags                      = merge(var.common_tags, {Name = "${var.nat.nat_name[count.index]} EIP"})
}

resource "aws_nat_gateway" "this" {
  count = length(var.nat.public_subnet_name)
  allocation_id             = aws_eip.this[count.index].id
  subnet_id                 = data.aws_subnet.public[count.index].id

  tags                      = merge(var.common_tags, {Name = "${var.nat.nat_name[count.index]}"})
}