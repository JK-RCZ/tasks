# This module depends on Subnets.
# Please set respective dependensies in root module!

# Private subnet list corresponds to public subnet, where respective NAT would be created
# e.g. private_subnet_name = ["priv 1", "priv 2", ... "priv N"]
#                                |        |            |
#                               \/       \/           \/
#      public_subnet_name = ["publ 1", "publ 2"], ... "publ N"]  
#                nat_name = ["NAT 1",  "NAT 2",  ...  "NAT N"]

variable "nat" {
    description                          = "NAT main options"
    type                                 = object({
      domain                             = string
      private_subnet_name                = list(string)
      public_subnet_name                 = list(string)
      nat_name                           = list(string)

    })
  
}

variable "common_tags" {
    description                          = "Tags suitable for all resources"
    type                                 = map
}