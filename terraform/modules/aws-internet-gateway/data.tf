
data "aws_vpc" "data" {
    tags                    = {
      Name                  = var.igw.vpc_name
    }
}