output "Route-Table-Data" {
   description         = "Route table main data"
    value              = [
        for i in range(length(var.route_table_nat.route_table_name)):
            {
                Name   = aws_route_table.uno[i].tags.Name
                ID     = aws_route_table.uno[i].id
            }
    ]        
}