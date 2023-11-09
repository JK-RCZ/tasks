
variable "vpc" {
    description             = "Variables for VPC"
    type                    = object({
      region                = string
      tenancy               = string
      cidr_block            = string
      name                  = string
    })
    default                 = {
      region                = "eu-west-2"
      tenancy               = "default"
      cidr_block            = "10.0.0.0/16"
      name                  = "tf-vpc"
    }
}

variable "common_tags" {
    description             = "Tags suitable for all resources"
    type                    = map
}
