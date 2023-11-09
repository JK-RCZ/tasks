
output "VPC-Data" {
    description  = "VPC main data"
    value        = {
            Name = aws_vpc.thing.tags.Name
            ID   = aws_vpc.thing.id
            CIDR = aws_vpc.thing.cidr_block
    }
}
