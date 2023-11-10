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
    type                                         = list(object({
      name                                       = string
      cidr_block                                 = string
      map_public_ip_on_launch                    = bool
      availability_zone                          = string
    }))
    
}

variable "igw_name" {
    description                                  = "IGW name"
    type                                         = string
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

variable "igw_route_table_params" {
    description                                  = "Name of route table, destination of route table, internet gateway and subnet names to stick route table to"
    type                                         = object({
      name                                       = string
      destination_cidr_block                     = string
      igw_name                                   = string
      subnet_name                                = list(string)
    })  
}

variable "nat_route_table_params" {
    description                                  = "Name of route table, destination of route table, subnet names to stick route table to"
    type                                         = object({
      destination_cidr_block                     = string
      private_subnet_name                        = list(string)
      route_table_name                           = list(string)
      nat_name                                   = list(string)
    })  
}

variable "ec2" {
    description                                  = "EC2, assotiated public key and security group parameters"
    type                                         = object({
      public_key_name                            = string
      vpc_name                                   = string
      security_group_parameters                  = object(
        {
            sg_name                              = string
            inbound_ports_to_open                = list(string)
        })
      instance_parameters                        = object(
        {
            instance_name                        = string
            instance_ami                         = string
            instance_type                        = string
            subnet_name                          = string
            associate_public_ip_address          = bool
            user_data_path                       = string
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

variable "target_group" {
    description                                  = "Target group parameters"
    type                                         = object({
      tg_name                                    = string
      tg_port                                    = string
      tg_protocol                                = string
      tg_target_type                             = string
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
        })
        password_params                          = object({
            length                               = string
            type                                 = string
        })
        security_group_params                    = object({
            vpc_name                             = string
            ingress_description                  = string
            ingress_port                         = string
            ingress_protocol                     = string
            ingress_cidr_blocks                  = list(string)
            ingress_ipv6_cidr_blocks             = list(string)
            ingress_prefix_list_ids              = list(string)
            ingress_self                         = bool
            ingress_security_group_names         = list(string)
        })
    })
}
