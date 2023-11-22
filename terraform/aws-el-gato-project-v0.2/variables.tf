variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}

variable "vpc" {
    description                                  = "Variables for VPC"
    type                                         = object({
      region                                     = string
      tenancy                                    = string
      cidr_block                                 = string
      name                                       = string
    })
}


variable "subnets" {
    description                                  = "Subnets"
    type                                         = object({
      subnets_params                             = list(object({
        name                                     = string
        cidr_block                               = string
        map_public_ip_on_launch                  = bool
        availability_zone                        = string
      }))
      vpc_name                                   = string
    })
}

variable "igw" {
    description                                  = "IGW parameters"
    type                                         = object({
      igw_name                                   = string
      vpc_name                                   = string
    })
}


variable "nat" {
    description                                  = "NAT main options"
    type                                         = object({
      domain                                     = string
      private_subnet_name                        = list(string)
      public_subnet_name                         = list(string)
      nat_name                                   = list(string)

    })
  
}

variable "route_table_igw" {
    description                                  = "This root table uses Internet Gateway as default target!"
    type                                         = object({
      name                                       = string
      destination_cidr_block                     = string
      igw_name                                   = string
      subnet_name                                = list(string)
      vpc_name                                   = string
    })
}

variable "route_table_nat" {
    description                                  = "Name of route table, destination of route table, subnet names to stick route table to"
    type                                         = object({
      destination_cidr_block                     = string
      vpc_name                                   = string
      private_subnet_name                        = list(string)
      route_table_name                           = list(string)
      nat_name                                   = list(string)
    })  
}

variable "ec2" {
    description                                  = "EC2 and assotiated security group parameters"
    type                                         = object({
      public_key_name                            = string
      instance_parameters                        = object(
        {
            instance_name                        = string
            instance_ami                         = string
            instance_type                        = string
            subnet_name                          = string
            associate_public_ip_address          = bool
            user_data_path                       = string
            security_group_names                 = list(string)
        })
      rds_instance_parameters                    = object({
        gather_rds_instance_data                 = bool
        rds_instance_name                        = string
        ssm_name                                 = string
        load_balancer_name                       = string
      })
    })
}

variable "public_key_contents" {
    description                                  = "Public key contents. Do not describe this variable in your tfvars file to securely input it either on prompt after terraform plan/apply command or add it to terraform enviroment variable before the launch by command: export TF_VAR_public_key_contents='your public key' "
    type                                         = string  
}

variable "load_balancer" {
    description                                  = "Load balancer parameters"
    type                                         = object({
        load_balancer_name                       = string
        internal_load_balancer                   = bool
        load_balancer_type                       = string
        security_group_names                     = list(string)
        subnet_names                             = list(string)
        enable_deletion_protection               = bool
    })
}

variable "tg_80" {
    description                                  = "Target group parameters"
    type                                         = object({
      tg_name                                    = string
      tg_port                                    = string
      tg_protocol                                = string
      tg_target_type                             = string
      listener_name                              = string
      vpc_name                                   = string
      instance_name                              = string
      load_balancer_name                         = string
    })
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

variable "sec_1" {
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

variable "sec_2" {
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

variable "ingress_from_existent_security_groups_for_sec_1" {
    description                                  = "List of security groups from which traffic allowed"
    type                                         = list(string)
}

variable "ingress_from_existent_security_groups_for_sec_2" {
    description                                  = "List of security groups from which traffic allowed"
    type                                         = list(string)
}

