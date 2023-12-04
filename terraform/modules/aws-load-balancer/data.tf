
data "aws_security_group" "security_group_id" {
    for_each                  = toset(var.load_balancer.security_group_names)
    tags                      = {
      Name                    = each.key
    }
}

data "aws_subnet" "subnet_id" {
    for_each                  = toset(var.load_balancer.subnet_names)
    tags                      = {
      Name                    = each.key
    }
}