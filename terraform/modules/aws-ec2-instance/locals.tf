
locals {
  sg_ids             = [
    for i in var.ec2.instance_parameters.security_group_names:
      data.aws_security_group.security_group_id[i].id 
  ]
}