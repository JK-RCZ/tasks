
output "rds_data" {
    description = "RDS main data"
    value = {
        name = aws_db_instance.this.identifier
        id   = aws_db_instance.this.id
        endpoint = aws_db_instance.this.address
    }
}