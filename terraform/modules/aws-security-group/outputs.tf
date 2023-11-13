output "Security-Group-Data" {
    description               = "Security group main data"
    value                     = {
        Name                  = aws_security_group.thing.tags.Name
        ID                    = aws_security_group.thing.id

    }
}