variable "rds" {
    description = "value"
    type = object({
      rds_params = object({
        subnet_names = list(string)
        rds_instance_name = string
        rds_family = string
      password_params = object({
        length = string
        type = string
      security_group_params = object({
        vpc_name = string
        ingress_description = string
        ingress_port = string
        ingress_protocol = string
        ingress_cidr_blocks = string
        ingress_ipv6_cidr_blocks = string
        ingress_prefix_list_ids = string
        ingress_self = string
        ingress_security_group_names = list()
      })  
      })

      })
    })
  
}

variable "common_tags" {
    description                         = "Tags suitable for all resources"
    type                                = map
}