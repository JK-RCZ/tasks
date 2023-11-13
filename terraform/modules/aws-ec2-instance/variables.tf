# This module depends on subnets and security groups.
# Please set respective dependensies in root module!

variable "ec2" {
    description                         = "EC2 and assotiated security group parameters"
    type                                = object({
      public_key_name                   = string
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
    })
}

variable "public_key_contents" {
    description                         = "Public key contents. Do not describe this variable in your tfvars file to securely input it either on prompt after terraform plan/apply command or add it to terraform enviroment variable before the launch by command: export TF_VAR_public_key_contents='your public key' "
    type                                = string  
}

variable "common_tags" {
    description                         = "Tags suitable for all resources"
    type                                = map
}