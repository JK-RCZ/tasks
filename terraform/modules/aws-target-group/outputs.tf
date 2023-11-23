
output "target-group-data" {
    value    = {
        name = aws_lb_target_group.this.name
        id   = aws_lb_target_group.this.id
    }
}
