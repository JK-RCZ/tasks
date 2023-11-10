output "Target-Group-Data" {
    value    = {
        Name = aws_lb_target_group.einz.name
        ID   = aws_lb_target_group.einz.id
    }
}
