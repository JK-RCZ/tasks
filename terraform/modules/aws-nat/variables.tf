variable "nat" {
    description                      = "NAT main options"
    type                             = object({
      name                           = string
      domain                         = string
      private_subnet_cidr_block      = string
      public_subnet_name             = string

    })
  
}

variable "common_tags" {
    description                      = "Tags suitable for all resources"
    type                             = map
}