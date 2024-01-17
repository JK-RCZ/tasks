locals {
  sg_ids             = [
<<<<<<< HEAD
    for i in var.ingress_from_existent_security_groups:
      data.aws_security_group.data[i].id 
=======
    for i in var.security_group.traffic_from_security_groups_only.security_groups_names:
      data.aws_security_group.security_group_id[i].id 
>>>>>>> ac429b2 (finished creating k8s scripts)
  ]
}