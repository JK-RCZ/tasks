
data "aws_vpc" "data" {
    tags                       = {
      Name                     = var.security_group.vpc_name
    }
}

data "aws_security_group" "data" {
    for_each                   = toset(var.allow_from_security_groups)
    tags                       = {
      Name                     = each.key
    }
}