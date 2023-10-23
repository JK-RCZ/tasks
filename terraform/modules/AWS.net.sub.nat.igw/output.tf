
output "VPC-Data" {
    description = "VPC main data"
    value = [
        {
            Name = aws_vpc.major.tags.Name,
            ID = aws_vpc.major.id,
            CIDR = aws_vpc.major.cidr_block
        }

    ]
  
}

output "Private-Subnet-Data" {
    description = "Subnet main data"
    value = [
        for i in range(length(var.private_subnets)):
            [
                {
                    Name = aws_subnet.minor_private[i].tags.Name,
                    Availability-zone = aws_subnet.minor_private[i].availability_zone,
                    CIDR-block = aws_subnet.minor_private[i].cidr_block,
                    ID = aws_subnet.minor_private[i].id
                }
            ]
    ]
}

output "Public-Subnet-Data" {
    description = "Subnet main data"
    value = [
        for i in range(length(var.public_subnets)):
            [
                {
                    Name = aws_subnet.minor_public[i].tags.Name,
                    Availability-zone = aws_subnet.minor_public[i].availability_zone,
                    CIDR-block = aws_subnet.minor_public[i].cidr_block,
                    ID = aws_subnet.minor_public[i].id
                }
            ]
    ]
}

output "Internet-Gateway-Data" {
    description = "Internet Gateway main data"
    value = [
        {
            Name = aws_internet_gateway.sky[*].tags.Name,
            ID =  aws_internet_gateway.sky[*].id,
            VPC-ID = aws_internet_gateway.sky[*].vpc_id
        }
    ]
}

output "Elastic-IPs-Data" {
   description = "Elastic IP main data"
    value = [
        for i in range(length(var.private_subnets)):
            [
                {
                    Name = aws_eip.nose[i].tags.Name,
                    Subnet-associations = aws_eip.nose[i].associate_with_private_ip,
                    Public-IP = aws_eip.nose[i].public_ip,
                    ID = aws_eip.nose[i].id
                }
            ]
    ]
  
}

output "NAT-Data" {
   description = "NAT main data"
    value = [
        for i in range(length(var.private_subnets)):
            [
                {
                    Name = aws_nat_gateway.one-way[i].tags.Name,
                    Public_IP = aws_nat_gateway.one-way[i].public_ip,
                    Subnet-ID = aws_nat_gateway.one-way[i].subnet_id,
                    ID = aws_nat_gateway.one-way[i].id
                }
            ]
    ]
  
}

output "Private-Route-Table-Data" {
   description = "Private Route table main data"
    value = [
        for i in range(length(var.private_subnets)):
            [
                {
                    Name = aws_route_table.skynet_private[i].tags.Name,
                    /*NAT-ID = aws_route_table.skynet_private[i].route.nat_gateway_id,*/
                    ID = aws_route_table.skynet_private[i].id
                }
            ]
    ]
}
output "Public-Route-Table-Data" {
   description = "Public route table main data"
    value = [
        {
            Name = aws_route_table.skynet.tags.Name,
            /*IGW-ID = aws_route_table.skynet.route.cidr_block,*/
            ID = aws_route_table.skynet.id
        }
    ]
}

output "Security-Group-Data" {
    description = "Security group main data"
    value = [{
        Name = aws_security_group.dog.tags.Name
        ID = aws_security_group.dog.id

    }]
}

output "Instance_Data" {
    description = "Instance main data"
    value = [
        for i in range(length(var.aws_instance)):
            [
                {
                    Name = aws_instance.entity[i].tags.Name,
                    ID = aws_instance.entity[i].id
                    Public_IP = aws_instance.entity[i].public_ip
                    Subnet_id = aws_instance.entity[i].subnet_id
                }
            ]
    ]
  
}