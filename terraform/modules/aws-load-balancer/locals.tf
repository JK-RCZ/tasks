
locals {
  security_group_ids = [
    for i in var.load_balancer.security_group_names:
      data.aws_security_group.security_group_id[i].id 
  ]
  subnet_ids         = [
    for i in var.load_balancer.subnet_names:
      data.aws_subnet.subnet_id[i].id 
  ]
}