# This module depends on VPC and Security groups(if inbound traffic alloud only from existing security groups).
# Please set respective dependensies in root module!

variable "security_group" {
    description                                  = "Security group ingress and egress parameters"
    type                                         = object(
        {
            vpc_name                             = string
            sg_name                              = string
            sg_descritption                      = string
            ingress                              = list(object(
                {
                    ingress_description          = string
                    ingress_port                 = string
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

variable "allow_from_security_groups" {
    description                                  = "List of security groups from which traffic will be allowed"
    type                                         = list(string)
}

variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}