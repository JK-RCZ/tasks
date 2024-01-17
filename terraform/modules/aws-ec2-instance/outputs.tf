output "Instance-Data" {
    description               = "Instance main data"
    value                     = {
<<<<<<< HEAD
        Name                  = aws_instance.zwei.tags.Name,
        ID                    = aws_instance.zwei.id
        Public_IP             = aws_instance.zwei.public_ip
        Subnet_id             = aws_instance.zwei.subnet_id
=======
        name                  = aws_instance.this.tags.Name,
        id                    = aws_instance.this.id
        public_ip             = aws_instance.this.public_ip
        private_ip            = aws_instance.this.private_ip
        subnet_id             = aws_instance.this.subnet_id
        volume_id             = aws_ebs_volume.this.id
>>>>>>> ac429b2 (finished creating k8s scripts)
    }
}

