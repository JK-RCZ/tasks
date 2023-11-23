
resource "aws_vpc" "this" {
  cidr_block         = var.vpc.cidr_block
  instance_tenancy   = var.vpc.tenancy
  tags               = merge(var.common_tags, {Name = "${var.vpc.name}"})
}
