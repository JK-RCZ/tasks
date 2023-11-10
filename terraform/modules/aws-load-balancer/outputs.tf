output "Load-Balancer-Data" {
   description   = "Load balancer main data"
    value        = {
        Name     = aws_lb.thing.name,
        DNS_name = aws_lb.thing.dns_name,
        ID       = aws_lb.thing.id
    }
}