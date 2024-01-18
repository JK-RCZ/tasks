
output "elastic_ip_data" {
   description                          = "Elastic IP main data"
   value                                = [
        for i in range(length(var.nat.private_subnet_name)):
            [
                {
                    name                = aws_eip.this[i].tags.Name,
                    subnet_associations = aws_eip.this[i].associate_with_private_ip,
                    public_ip           = aws_eip.this[i].public_ip,
                    id                  = aws_eip.this[i].id
                }
            ]
   ]
}

output "nat_data" {
   description              = "NAT main data"
    value                   = [
        for i in range(length(var.nat.private_subnet_name)):
            [
                {
                    name                = aws_nat_gateway.this[i].tags.Name,
                    public_ip           = aws_nat_gateway.this[i].public_ip,
                    subnet_ip           = aws_nat_gateway.this[i].subnet_id,
                    id                  = aws_nat_gateway.this[i].id
                }
            ]
    ]            
}