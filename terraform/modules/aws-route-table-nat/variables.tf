# This module uses NAT as a target

# This module depends on Subnets, VPC and NAT(s).
# Please set respective dependensies in root module!



# Private subnet list corresponds to root table name whitch connects subnet to apropriate NAT

# e.g. private_subnet_name = ["priv 1",  "priv 2", ...  "priv N"]
#                                |         |               |
#                               \/        \/              \/
#        root_table_name = ["route 1", "route 2"], ... "route N"]  
#                nat_name = ["NAT 1",  "NAT 2",  ...  "NAT N"]

variable "route_table_nat" {
    description                                  = "This root table uses NAT(s) as default target!"
    type                                         = object({
      destination_cidr_block                     = string
      vpc_name                                   = string
      private_subnet_name                        = list(string)
      route_table_name                           = list(string)
      nat_name                                   = list(string)
    })  
}

variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}