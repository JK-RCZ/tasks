output "route_table_data" {
   description = "Route table main data"
    value      = {
        name   = aws_route_table.this.tags.Name
        id     = aws_route_table.this.id
    }
}