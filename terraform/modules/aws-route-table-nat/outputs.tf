output "Route-Table-Data" {
   description = "Route table main data"
    value      = {
        Name   = aws_route_table.uno.tags.Name
        ID     = aws_route_table.uno.id
    }
}