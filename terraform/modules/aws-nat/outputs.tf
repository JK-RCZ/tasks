output "Elastic-IP-Data" {
   description                          = "Elastic IP main data"
   value                                = [
        for i in range(length(var.nat.private_subnet_name)):
            [
                {
                    Name                = aws_eip.uno[i].tags.Name,
                    Subnet-associations = aws_eip.uno[i].associate_with_private_ip,
                    Public-IP           = aws_eip.uno[i].public_ip,
                    ID                  = aws_eip.uno[i].id
                }
            ]
   ]
}


output "NAT-Data" {
   description              = "NAT main data"
    value                   = [
        for i in range(length(var.nat.private_subnet_name)):
            [
                {
                    Name                = aws_nat_gateway.due[i].tags.Name,
                    Public_IP           = aws_nat_gateway.due[i].public_ip,
                    Subnet-ID           = aws_nat_gateway.due[i].subnet_id,
                    ID                  = aws_nat_gateway.due[i].id
                }
            ]
    ]            
}