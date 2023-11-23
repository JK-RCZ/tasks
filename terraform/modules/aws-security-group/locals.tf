
locals {
  sg_ids             = [
    for i in var.allow_from_security_groups:
      data.aws_security_group.data[i].id 
  ]
}