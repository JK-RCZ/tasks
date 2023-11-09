
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

variable "public_key" {
    description = "Public key to access instance"
    type =  string
}

variable "security_group" {
    description = "Ingress ports for EC2"
    type = object({
      name = string
      ports = list(string)
    })
}

variable "vpc_name" {
  description = "VPC name to stick security group to"
  type = string  
}

variable "subnet_name" {
    description = "Subnet name to stick instance to"
    type = string
}

variable "public_subnets_ids" {
    description = "Public subnets ID's to stick load balancer to if chosen 'associate_public_ip_address = false'"
    type = list(string)
}

variable "private_subnets_ids" {
    description = "Private subnets ID's to stick DB subnets group to"
    type = list(string)
}

variable "aws_instance" {
    description = "Instances to create"
    type = object({
      name = string
      associate_public_ip_address = bool
      ami = string
      instance_type = string
      user_data_path = string
    })
}



variable "db-parameter-group" {
    description = "Options for DB parameter group"
    type = string
}

variable "rds_instance" {
    description = "Rds to create"
    type = object({
        rds_instance_name    = string
        allocated_storage    = string
        storage_type         = string
        db_name              = string
        engine               = string
        engine_version       = string
        instance_class       = string
        username             = string
        skip_final_snapshot  = string
        publicly_accessible  = bool
        
    })
}

