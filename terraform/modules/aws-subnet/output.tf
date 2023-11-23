
output "subnet-data" {
    description                       = "Subnet main data"
    value                             = [
        for i in range(length(var.subnets)):
            [
                {
                    name              = aws_subnet.this[i].tags.Name
                    type              = aws_subnet.this[i].tags.Type
                    availability-zone = aws_subnet.this[i].availability_zone,
                    cidr-block        = aws_subnet.this[i].cidr_block,
                    id                = aws_subnet.this[i].id
                }
            ]
    ]
}