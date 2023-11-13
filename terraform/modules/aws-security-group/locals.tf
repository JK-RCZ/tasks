locals {
  sg_ids             = [
    for i in var.ingress_from_existent_security_groups:
      data.aws_security_group.data[i].id 
  ]
}