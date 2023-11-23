
data "aws_security_group" "data" {
    for_each                  = toset(var.load_balancer.security_group_names)
    tags                      = {
      Name                    = each.key
    }
}

data "aws_subnet" "data" {
    for_each                  = toset(var.load_balancer.subnet_names)
    tags                      = {
      Name                    = each.key
    }
}