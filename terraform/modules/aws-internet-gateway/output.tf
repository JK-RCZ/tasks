output "Internet-Gateway-Data" {
    description = "Internet Gateway main data"
    value = {
        Name = aws_internet_gateway.thing.tags.Name,
        ID =  aws_internet_gateway.thing.id,
        VPC-ID = aws_internet_gateway.thing.vpc_id
    }
}