
output "Security-Group-Data" {
    description = "Security group main data"
    value = [{
        Name = aws_security_group.dog.tags.Name
        ID = aws_security_group.dog.id

    }]
}

output "Instance_Data" {
    description = "Instance main data"
    value =     {
                    Name = aws_instance.entity.tags.Name,
                    ID = aws_instance.entity.id
                    Public_IP = aws_instance.entity.public_ip
                    Subnet_id = aws_instance.entity.subnet_id
                }
            
    
  
}