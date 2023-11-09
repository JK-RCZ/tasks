output "Subnet-Data" {
    description                       = "Subnet main data"
    value                             = [
        for i in range(length(var.subnets)):
            [
                {
                    Name              = aws_subnet.thing[i].tags.Name
                    Type              = aws_subnet.thing[i].tags.Type
                    Availability-zone = aws_subnet.thing[i].availability_zone,
                    CIDR-block        = aws_subnet.thing[i].cidr_block,
                    ID                = aws_subnet.thing[i].id
                }
            ]
    ]
}