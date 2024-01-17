# This module depends on Subnets, Security Groups, RDS Instance (if applicapable), SSM Parameter (if applicapable).
# Please set respective dependensies in root module!

variable "ec2" {
    description                         = "EC2, assotiated security group and RDS instance parameters"
    type                                = object({
      public_key_name                     = string
      instance_parameters               = object(
        {
            instance_name               = string
            instance_ami                = string
            instance_type               = string
            subnet_name                 = string
            associate_public_ip_address = bool
            user_data_path              = string
            security_group_names        = list(string)
        })
      rds_instance_parameters           = object({
        gather_rds_instance_data        = bool
        rds_instance_name               = string
        ssm_name                        = string
        load_balancer_name              = string
      })
    })
}

variable "public_key_contents" {
  description = "Contents of public key to use in EC2"
  type = string
}

variable "common_tags" {
    description                         = "Tags suitable for all resources"
    type                                = map
}