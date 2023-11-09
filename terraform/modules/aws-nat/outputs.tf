output "Elastic-IP-Data" {
   description              = "Elastic IP main data"
    value                   = {
        Name                = aws_eip.uno.tags.Name,
        Subnet-associations = aws_eip.uno.associate_with_private_ip,
        Public-IP           = aws_eip.uno.public_ip,
        ID                  = aws_eip.uno.id
    }
}

output "NAT-Data" {
   description              = "NAT main data"
    value                   = {
        Name                = aws_nat_gateway.due.tags.Name,
        Public_IP           = aws_nat_gateway.due.public_ip,
        Subnet-ID           = aws_nat_gateway.due.subnet_id,
        ID                  = aws_nat_gateway.due.id
    }
}