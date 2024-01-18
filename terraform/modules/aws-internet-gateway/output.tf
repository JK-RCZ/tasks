
output "internet_gateway_data" {
    description = "Internet Gateway main data"
    value       = {
        name    = aws_internet_gateway.this.tags.Name,
        id      =  aws_internet_gateway.this.id,
        vpc_id  = aws_internet_gateway.this.vpc_id
    }
}