output "load-balancer-data" {
   description   = "Load balancer main data"
    value        = {
        name     = aws_lb.this.name,
        dns_name = aws_lb.this.dns_name,
        id       = aws_lb.this.id
    }
}