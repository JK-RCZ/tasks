#This module depends on Security Group and Subnets. 
# Please set respective dependensies in root module!


variable "load_balancer" {
    description                         = "Load balancer parameters"
    type                                = object({
        load_balancer_name              = string
        internal_load_balancer          = bool
        load_balancer_type              = string
        security_group_names            = list(string)
        subnet_names                    = list(string)
        enable_deletion_protection      = bool
    })
}

variable "common_tags" {
    description                         = "Tags suitable for all resources"
    type                                = map
}