
output "vpc_data" {
    description        = "VPC main data"
    value              = {
            name       = aws_vpc.this.tags.Name
            id         = aws_vpc.this.id
            cidr       = aws_vpc.this.cidr_block
            kms_key_id = var.vpc.ebs_encryption_params.enable_ebs_encryption ? aws_kms_key.this[0].id : null
    }
}
