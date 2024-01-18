output "Instance-Data" {
    description               = "Instance main data"
    value                     = {
        name                  = aws_instance.this.tags.Name,
        id                    = aws_instance.this.id
        public_ip             = aws_instance.this.public_ip
        private_ip            = aws_instance.this.private_ip
        subnet_id             = aws_instance.this.subnet_id
        volume_id             = aws_ebs_volume.this.id
    }
}

