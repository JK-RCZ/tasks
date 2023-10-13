
output "vpc_data" {
    description = "VPC main data"
    value = [
        {
            VPC-Name = aws_vpc.major.tags.Name,
            VPC-ID = aws_vpc.major.id,
            VPC-CIDR = aws_vpc.major.cidr_block
        }

    ]
  
}

output "subnet_data" {
    description = "Subnet main data"
    value = [
        for i in range(length(var.subnets)):
            [
                {
                    Name = aws_subnet.minor[i].tags.Name,
                    Availability-zone = aws_subnet.minor[i].availability_zone,
                    CIDR-block = aws_subnet.minor[i].cidr_block,
                    Subnet-ID = aws_subnet.minor[i].id
                }
            ]
    ]
  
}
