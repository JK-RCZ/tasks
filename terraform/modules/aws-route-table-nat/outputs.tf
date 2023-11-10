output "Route-Table-Data" {
   description         = "Route table main data"
    value              = [
        for i in range(length(var.nat_route_table_params.route_table_name)):
            {
                Name   = aws_route_table.uno[i].tags.Name
                ID     = aws_route_table.uno[i].id
            }
    ]        
}