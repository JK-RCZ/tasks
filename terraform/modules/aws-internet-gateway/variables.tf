# This module depends on VPC.
# Please set respective dependensies in root module!

variable "igw" {
    description                 = "IGW name and respective VPC name"
    type                        = object({
      igw_name                  = string
      vpc_name                  = string
    })
}

variable "common_tags" {
    description                 = "Tags suitable for all resources"
    type                        = map
}