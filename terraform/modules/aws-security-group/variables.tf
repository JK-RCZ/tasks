# This module depends on VPC and Security groups(if inbound traffic alloud only from existing security groups).
# Please set respective dependensies in root module!

variable "security_group" {
    description                                  = "Security group ingress and egress parameters"
    type                                         = object(
        {
            vpc_name                             = string
            sg_name                              = string
            sg_descritption                      = string
            traffic_from_security_groups_only    = object({
              allow_traffic                      = bool
              security_groups_names              = list(string) # list security group names, that you want to allow traffic from (enabled only if allow_traffic = true)
            })
            ingress                              = list(object(
                {
                    ingress_description          = string
                    ingress_from_port            = string
                    ingress_to_port              = string
                    ingress_protocol             = string
                    ingress_cidr_blocks          = list(string)
                    ingress_ipv6_cidr_blocks     = list(string)
                    ingress_prefix_list_ids      = list(string)
                    ingress_self                 = bool
                }
            ))
            egress                               = object(
                {
                    egress_description           = string
                    egress_port                  = string
                    egress_protocol              = string
                    egress_cidr_blocks           = list(string)
            })
        })
  
}

<<<<<<< HEAD
variable "ingress_from_existent_security_groups" {
    description                                  = "List of security groups from which traffic allowed"
    type                                         = list(string)
}

=======
>>>>>>> ac429b2 (finished creating k8s scripts)
variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}