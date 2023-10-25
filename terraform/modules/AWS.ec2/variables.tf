variable "common_tags" {
    description = "Tags suitable for all resources"
    type        = map
}

variable "public-key" {
    description = "Public key to access instance"
    type =  string
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

variable "public_subnets_ids" {
    description = "Public subnets ID's to stick load balancer to if chosen 'associate_public_ip_address = false'"
    type = list(string)
}

variable "aws_instance" {
    description = "Instance to create"
    type = object({
      name = string
      associate_public_ip_address = bool
      ami = string
      instance_type = string
      user_data_path = string
      
    })
}