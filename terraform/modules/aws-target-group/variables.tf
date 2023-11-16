#  This module depends on VPC, Instance and Load Balancer.
#  Please set respective dependensies in root module!

variable "target_group" {
    description                         = "Target group parameters"
    type                                = object({
      tg_name                           = string
      tg_port                           = string
      tg_protocol                       = string
      tg_target_type                    = string
      listener_name                     = string
      vpc_name                          = string
      instance_name                     = string
      load_balancer_name                = string
    })
}

variable "common_tags" {
    description                         = "Tags suitable for all resources"
    type                                = map
}