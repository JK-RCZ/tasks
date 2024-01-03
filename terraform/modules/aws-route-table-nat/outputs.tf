output "route_table_data" {
   description         = "Route table main data"
    value              = [
        for i in range(length(var.route_table_nat.route_table_name)):
            {
                name   = aws_route_table.this[i].tags.Name
                id     = aws_route_table.this[i].id
            }
    ]        
}