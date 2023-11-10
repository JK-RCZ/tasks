output "RDS-Data" {
    description = "RDS main data"
    value = {
        Name = aws_db_instance.sechs.identifier
        ID   = aws_db_instance.sechs.id
        Endpoint = aws_db_instance.sechs.address

    }
  
}