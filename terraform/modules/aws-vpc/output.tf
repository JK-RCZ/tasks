
output "vpc_data" {
    description  = "VPC main data"
    value        = {
            name = aws_vpc.this.tags.Name
            id   = aws_vpc.this.id
            cidr = aws_vpc.this.cidr_block
    }
}
