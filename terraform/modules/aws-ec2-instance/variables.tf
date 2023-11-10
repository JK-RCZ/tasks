variable "ec2" {
    description                         = "EC2 and assotiated security group parameters"
    type                                = object({
      public_key_name                   = string
      vpc_name                          = string
      security_group_parameters         = object(
        {
            sg_name                     = string
            inbound_ports_to_open       = list(string)
        })
      instance_parameters               = object(
        {
            instance_name               = string
            instance_ami                = string
            instance_type               = string
            subnet_name                 = string
            associate_public_ip_address = bool
            user_data_path              = string
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