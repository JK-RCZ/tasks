output "RDS-Data" {
    description = "RDS main data"
    value = {
        Name = aws_db_instance.funf.identifier
        ID   = aws_db_instance.funf.id
        Endpoint = aws_db_instance.funf.address

    }
  
}