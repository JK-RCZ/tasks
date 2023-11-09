variable "common_tags" {
    description                      = "Tags suitable for all resources"
    type                             = map
}

variable "vpc" {
    description                      = "Variables for VPC"
    type                             = object({
      region                         = string
      tenancy                        = string
      cidr_block                     = string
      name                           = string
    })
}


variable "subnets" {
    description                      = "Subnets"
    type                             = list(object({
      name                           = string
      cidr_block                     = string
      map_public_ip_on_launch        = bool
      availability_zone              = string
    }))
    
}

variable "igw_name" {
    description                      = "IGW name"
    type                             = string
}

variable "nat" {
    description                      = "NAT main options"
    type                             = object({
      name                           = string
      domain                         = string
      private_subnet_cidr_block      = string
      public_subnet_name             = string

    })
  
}

variable "igw_route_table_params" {
    description                                  = "Name of route table, destination of route table, subnet names to stick route table to"
    type                                         = object({
      name                                       = string
      destination_cidr_block                     = string
      subnet_name                                = list(string)
    })  
}

variable "nat_route_table_params" {
    description                                  = "Name of route table, destination of route table, subnet names to stick route table to"
    type                                         = object({
      name                                       = string
      destination_cidr_block                     = string
      subnet_name                                = list(string)
    })  
}

