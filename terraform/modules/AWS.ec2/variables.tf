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
    type = object({
      name = string
      ports = list(string)
    })
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

variable "subnet_ids" {
    description = "Subnets for DB subnets group"
    type        = list(string)
    
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
        password             = string
        skip_final_snapshot  = string
        publicly_accessible  = bool
        
    })
}

