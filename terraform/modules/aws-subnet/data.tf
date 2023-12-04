
data "aws_vpc" "vpc_id" {
    tags                      = {
      Name                    = var.subnets.vpc_name
    }
}
