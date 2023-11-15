
variable "vpc" {
    description             = "VPC parameters"
    type                    = object({
      region                = string
      tenancy               = string
      cidr_block            = string
      name                  = string
    })
}

variable "common_tags" {
    description             = "Tags suitable for all resources"
    type                    = map
}
