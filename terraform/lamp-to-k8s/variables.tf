variable "vpc_region" {
    type                                         = string  
}

variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}

variable "rds" {
    description                                  = "RDS, RDS password and RDS security group parameters"
    type                                         = object({
        rds_params                               = object({
            subnet_names                         = list(string)
            rds_instance_name                    = string
            rds_family                           = string
            rds_allocated_storage                = string
            rds_storage_type                     = string
            rds_db_name                          = string
            rds_engine                           = string
            rds_engine_version                   = string
            rds_instance_class                   = string
            rds_username                         = string
            rds_skip_final_snapshot              = bool
            rds_publicly_accessible              = bool
            rds_security_group_names             = list(string)
        })
        password_params                          = object({
            name                                 = string
            length                               = string
            type                                 = string
        })
    })
}

variable "rds_security_group" {
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