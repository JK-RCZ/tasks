#  This module depends on Subnets and Security Groups.
#  Please set respective dependensies in root module!

variable "rds" {
    description                          = "RDS, RDS password and RDS security group parameters"
    type                                 = object({
        rds_params                       = object({
            subnet_names                 = list(string)
            rds_instance_name            = string
            rds_family                   = string
            rds_allocated_storage        = string
            rds_storage_type             = string
            rds_db_name                  = string
            rds_engine                   = string
            rds_engine_version           = string
            rds_instance_class           = string
            rds_username                 = string
            rds_skip_final_snapshot      = bool
            rds_publicly_accessible      = bool
            rds_security_group_names     = list(string)
        })
        password_params                  = object({
            length                       = string
            type                         = string
        })
    })
}

variable "common_tags" {
    description                          = "Tags suitable for all resources"
    type                                 = map
}