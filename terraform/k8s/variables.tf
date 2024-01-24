
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
      ebs_encryption_params                      = object({
        enable_ebs_encryption                    = bool
        deletion_window_in_days                  = string
        customer_master_key_spec                 = string
      })
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

variable "s3_bucket" {
    description                                  = "S3 bucket parameters"
    type                                         = object({
      bucket_name                                = string
      bucket_versioning                          = string 
      s3_encryption_params                       = object({
        enble_encryption                         = bool
        deletion_window_in_days                  = string
        customer_master_key_spec                 = string
      })
      s3_intelligent_tiering_params              = object({
        enable_intelligent_tiering               = bool
        intelligent_tiering_config_name          = string  
        days_after_deep_archive_access_allowed   = string
        days_after_archive_access_allowed        = string
      })
    })
}

variable "ec2_master" {
    description                                  = "EC2, assotiated security group and RDS instance parameters"
    type                                         = object({
      public_key_name                            = string
      instance_parameters                        = object(
        {
            instance_name                        = string
            instance_ami                         = string
            instance_type                        = string
            volume_path                          = string
            volume_size_gb                       = string
            subnet_name                          = string
            associate_public_ip_address          = bool
            user_data_path                       = string
            security_group_names                 = list(string)
        })
      rds_instance_parameters                    = object({
        gather_rds_instance_data                 = bool
        rds_instance_name                        = string
        ssm_key_name                             = string
        load_balancer_name                       = string
      })
      instance_profile_parameters                = object({
        create_instance_profile                  = bool
        instance_profile_name                    = string
        attach_role_name                         = string
      })
    })
}

variable "public_key_contents" {
  description                                    = "Contents of public key to use in EC2"
  type                                           = string
}

variable "ec2_worker" {
    description                                  = "EC2, assotiated security group and RDS instance parameters"
    type                                         = object({
      public_key_name                          = string
      instance_parameters                        = object(
        {
            instance_name                        = string
            instance_ami                         = string
            instance_type                        = string
            volume_path                          = string
            volume_size_gb                       = string
            subnet_name                          = string
            associate_public_ip_address          = bool
            user_data_path                       = string
            security_group_names                 = list(string)
        })
      rds_instance_parameters                    = object({
        gather_rds_instance_data                 = bool
        rds_instance_name                        = string
        ssm_key_name                             = string
        load_balancer_name                       = string
      })
      instance_profile_parameters                = object({
        create_instance_profile                  = bool
        instance_profile_name                    = string
        attach_role_name                         = string
      })
    })
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

variable "security_k8s_master_node" {
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

variable "security_k8s_worker_node" {
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

variable "ec2_role_1" {
    description                                  = "Specify trusted entities policy file path and policies arns that you want to apply to this role"
    type                                         = object({
        iam_role_name                            = string
        trusted_entities_policy_file_path        = string
        policy_name                              = string
    })
  
}

variable "iam_policy" {
    description                                  = "IAM policy main parameters"
    type                                         = object({
      policy_name                                = string
      policy_path                                = string
      policy_json_file_path                      = string
    })
}
