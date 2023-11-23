
data "aws_vpc" "data" {
    tags                      = {
      Name                    = var.subnets.vpc_name
    }
}
