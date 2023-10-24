variable "common_tags" {
    description = "Tags suitable for all resources"
    type        = map
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

variable "vpc_id" {
  description = "VPC name to stick security group to"
  type = string  
}

variable "subnet_id" {
    description = "Subnet ID to stick instance to"
    type = string
}

variable "aws_instance" {
    description = "Instance to create"
    type = object({
      name = string
      ami = string
      instance_type = string
      user_data_path = string
      
    })
}