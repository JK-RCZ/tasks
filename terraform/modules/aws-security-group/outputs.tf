
output "security-group-data" {
    description               = "Security group main data"
    value                     = {
        name                  = aws_security_group.this.tags.Name
        id                    = aws_security_group.this.id
    }
}