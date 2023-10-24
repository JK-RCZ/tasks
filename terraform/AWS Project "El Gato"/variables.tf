
variable "vpc_parameters" {
    description = "Variables for VPC"
    type = object(
      {
      region = string
      vpc_cidr_block = string
      vpc_name_tag = string
      internnet_gw_name_tag = string
      }
    )
}

variable "common_tags" {
    description = "Tags suitable for all resources"
    type        = map
}

variable "private_subnets" {
    description = "list of subnets"
    type = list(object({
      name = string
      cidr_block = string
      availability_zone = string
    }))
}

variable "public_subnets" {
    description = "list of subnets"
    type = list(object({
      name = string
      cidr_block = string
      availability_zone = string
    }))
}

variable "ssh_key" {
    description = "SSH key options"
    type = object({
      name = string
      contents = string
    })
  
}

variable "security_group" {
    description = "Ingress ports for EC2"
    type = list(string)
    
}
variable "vpc_name" {
  description = "VPC name to stick security group to"
  type = string  
}

variable "subnet_name" {
    description = "Subnet name to stick instance to"
    type = string
}

variable "aws_instance" {
    description = "Instances to create"
    type = object({
      name = string
      ami = string
      instance_type = string
      user_data_path = string
    })
}

