
locals {
  subnet_ids         = [
    for i in var.rds.rds_params.subnet_names:
      data.aws_subnet.data[i].id 
  ]
  sg_ids             = [
    for i in var.rds.rds_params.rds_security_group_names:
      data.aws_security_group.data[i].id 
  ]
}