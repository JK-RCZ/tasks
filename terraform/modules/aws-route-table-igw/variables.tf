# This module uses internet gateway as a target

# This module depends on Subnets, VPC and Internet Gateway.
# Please set respective dependensies in root module!

variable "route_table_igw" {
    description                                  = "This root table uses Internet Gateway as default target!"
    type                                         = object({
      name                                       = string
      destination_cidr_block                     = string
      igw_name                                   = string
      subnet_name                                = list(string)
      vpc_name                                   = string
    })
}

variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}