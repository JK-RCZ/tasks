
output "Security-Group-Data" {
    description = "Security group main data"
    value = [{
        Name = aws_security_group.dog.tags.Name
        ID = aws_security_group.dog.id

    }]
}

output "Instance-Data" {
    description = "Instance main data"
    value =     {
                    Name = aws_instance.entity.tags.Name,
                    ID = aws_instance.entity.id
                    Public_IP = aws_instance.entity.public_ip
                    Subnet_id = aws_instance.entity.subnet_id
                }
            
    
  
}

output "Load-Balancer-Data" {
   description = "Load balancer main data"
    value = var.aws_instance.associate_public_ip_address ? null : {
        Name = aws_lb.multi-pulti[0].name,
        DNS_name = aws_lb.multi-pulti[0].dns_name,
        ID = aws_lb.multi-pulti[0].id
    }
}

output "RDS-Data" {
    description = "RDS main data"
    value = {
        Name = aws_db_instance.lamp-db.identifier
        ID   = aws_db_instance.lamp-db.id
        Endpoint = aws_db_instance.lamp-db.address

    }
  
}
