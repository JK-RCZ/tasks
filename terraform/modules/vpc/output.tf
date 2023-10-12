output "id" {
    description = "VPC id"
    value = aws_vpc.major.id
}
output "CIDR_block" {
    description = "VPC CIDR"
    value = aws_vpc.major.cidr_block
}