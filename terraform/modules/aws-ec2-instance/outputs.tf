output "Instance-Data" {
    description               = "Instance main data"
    value                     = {
        Name                  = aws_instance.zwei.tags.Name,
        ID                    = aws_instance.zwei.id
        Public_IP             = aws_instance.zwei.public_ip
        Subnet_id             = aws_instance.zwei.subnet_id
    }
}

