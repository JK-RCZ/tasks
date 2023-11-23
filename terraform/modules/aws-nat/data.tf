
data "aws_subnet" "private" {
  count = length(var.nat.private_subnet_name)
  tags                      = {
    Name                    = var.nat.private_subnet_name[count.index]  
  }
}

data "aws_subnet" "public" {
  count = length(var.nat.public_subnet_name)
  tags                      = {
    Name                    = var.nat.public_subnet_name[count.index]  
  }
}