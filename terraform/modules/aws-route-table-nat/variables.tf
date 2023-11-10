# Private subnet list corresponds to root table name whitch connects subnet to apropriate NAT

# e.g. private_subnet_name = ["priv 1",  "priv 2", ...  "priv N"]
#                                |         |               |
#                               \/        \/              \/
#        root_table_name = ["route 1", "route 2"], ... "route N"]  
#                nat_name = ["NAT 1",  "NAT 2",  ...  "NAT N"]



variable "vpc_id" {
    description                                  = "VPC ID route table would belong to"
    type                                         = string
}


variable "nat_route_table_params" {
    description                                  = "Name of route table, destination of route table, subnet names to stick route table to"
    type                                         = object({
      destination_cidr_block                     = string
      private_subnet_name                        = list(string)
      route_table_name                           = list(string)
      nat_name                                   = list(string)
    })  
}

variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}