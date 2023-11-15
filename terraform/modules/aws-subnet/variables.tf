# This module depends on VPC.
# Please set respective dependensies in root module!

variable "subnets" {
    description                   = "Subnets parameters"
    type                          = object({
      subnets_params              = list(object({
        name                      = string
        cidr_block                = string
        map_public_ip_on_launch   = bool
        availability_zone         = string
      }))
      vpc_name                    = string
    })
}

variable "common_tags" {
    description                   = "Tags suitable for all resources"
    type                          = map
}

