#This module depends on subnets, please set respective dependensies in root module

resource "aws_eip" "uno" {
  domain                    = var.nat.domain
  associate_with_private_ip = var.nat.private_subnet_cidr_block 
  
  tags                      = merge(var.common_tags, {Name = "${var.nat.name} EIP"})
}

data "aws_subnet" "public_subnet" {
  tags                      = {
    Name                    = var.nat.public_subnet_name  }
  
  depends_on                = [ resource.aws_eip.uno ]
}


resource "aws_nat_gateway" "due" {
  allocation_id             = aws_eip.uno.id
  subnet_id                 = data.aws_subnet.public_subnet.id

  tags                      = merge(var.common_tags, {Name = "${var.nat.name}"})
}