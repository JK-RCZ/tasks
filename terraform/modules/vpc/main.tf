resource "aws_vpc" "major" {
  cidr_block                = var.vpc_cidr_block
  instance_tenancy          = "default"

  tags = var.tags 
 
}
