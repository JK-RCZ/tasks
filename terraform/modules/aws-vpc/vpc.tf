
resource "aws_vpc" "this" {
  cidr_block               = var.vpc.cidr_block
  instance_tenancy         = var.vpc.tenancy
  tags                     = merge(var.common_tags, {Name = "${var.vpc.name}"})
}

resource "aws_kms_key" "this" {
  count                    = var.vpc.ebs_encryption_params.enable_ebs_encryption ? 1 : 0
  deletion_window_in_days  = var.vpc.ebs_encryption_params.deletion_window_in_days
  customer_master_key_spec = var.vpc.ebs_encryption_params.customer_master_key_spec
  tags                     = merge(var.common_tags, {Name = "${var.vpc.name}"})
}

resource "aws_ebs_default_kms_key" "this" {
  count                    = var.vpc.ebs_encryption_params.enable_ebs_encryption ? 1 : 0
  key_arn                  = aws_kms_key.this[0].arn
}

resource "aws_ebs_encryption_by_default" "this" {
  count                    = var.vpc.ebs_encryption_params.enable_ebs_encryption ? 1 : 0
  enabled                  = true
}