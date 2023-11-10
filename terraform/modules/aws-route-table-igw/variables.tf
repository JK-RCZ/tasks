variable "vpc_id" {
    description                                  = "VPC ID route table would belong to"
    type                                         = string
}


variable "igw_route_table_params" {
    description                                  = "Name of route table, destination of route table, internet gateway and subnet names to stick route table to"
    type                                         = object({
      name                                       = string
      destination_cidr_block                     = string
      igw_name                                   = string
      subnet_name                                = list(string)
    })  
}

variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}