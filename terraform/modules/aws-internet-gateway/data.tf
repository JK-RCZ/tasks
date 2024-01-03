
data "aws_vpc" "vpc_id" {
    tags                    = {
      Name                  = var.igw.vpc_name
    }
}