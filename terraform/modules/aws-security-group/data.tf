
data "aws_vpc" "vpc_id" {
    tags                       = {
      Name                     = var.security_group.vpc_name
    }
}

data "aws_security_group" "security_group_id" {
    for_each                   = toset(var.allow_from_security_groups)
    tags                       = {
      Name                     = each.key
    }
}