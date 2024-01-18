
locals {
  sg_ids             = [
    for i in var.security_group.traffic_from_security_groups_only.security_groups_names:
      data.aws_security_group.security_group_id[i].id 
  ]
}