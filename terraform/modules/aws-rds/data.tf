
data "aws_subnet" "data" {
    for_each               = toset(var.rds.rds_params.subnet_names)
    tags                   = {
      Name                 = each.key
    }
}

data "aws_security_group" "data" {
    for_each               = toset(var.rds.rds_params.rds_security_group_names)
    tags                   = {
      Name                 = each.key
    }
}