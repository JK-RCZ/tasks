output "Security-Group-Data" {
    description               = "Security group main data"
    value                     = {
        Name                  = aws_security_group.zwei.tags.Name
        ID                    = aws_security_group.zwei.id

    }
}

output "Instance-Data" {
    description               = "Instance main data"
    value                     = {
        Name                  = aws_instance.drei.tags.Name,
        ID                    = aws_instance.drei.id
        Public_IP             = aws_instance.drei.public_ip
        Subnet_id             = aws_instance.drei.subnet_id
    }
}