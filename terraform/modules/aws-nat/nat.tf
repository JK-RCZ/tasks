# This module depends on Subnets.
# Please set respective dependensies in root module!


data "aws_subnet" "private_subnet" {
  count = length(var.nat.private_subnet_name)
  tags                      = {
    Name                    = var.nat.private_subnet_name[count.index]  
  }
}

data "aws_subnet" "public_subnet" {
  count = length(var.nat.private_subnet_name)
  tags                      = {
    Name                    = var.nat.public_subnet_name[count.index]  
  }
}

resource "aws_eip" "uno" {
  count = length(var.nat.private_subnet_name)
  domain                    = var.nat.domain
  associate_with_private_ip = data.aws_subnet.private_subnet[count.index].cidr_block 
  
  tags                      = merge(var.common_tags, {Name = "${var.nat.nat_name[count.index]} EIP"})
}

resource "aws_nat_gateway" "due" {
  count = length(var.nat.private_subnet_name)
  allocation_id             = aws_eip.uno[count.index].id
  subnet_id                 = data.aws_subnet.public_subnet[count.index].id

  tags                      = merge(var.common_tags, {Name = "${var.nat.nat_name[count.index]}"})
}