
variable "subnets" {
    description                 = "Subnets"
    type                        = list(object({
      name                      = string
      cidr_block                = string
      map_public_ip_on_launch   = bool
      availability_zone         = string
    }))
    default                     = [ 
      {
        name                    = "tf-subnet-private"
        cidr_block              = "10.0.0.0/17"
        map_public_ip_on_launch = false
        availability_zone       = "eu-west-2a"
      },
      {
        name                    = "tf-subnet-public"
        cidr_block              = "10.0.0.128/17"
        map_public_ip_on_launch = true
        availability_zone       = "eu-west-2a"
      },
    ]
}

variable "vpc_id" {
  description                   = "VPC ID to deploy subnets"
  type                          = string
}

variable "common_tags" {
    description                 = "Tags suitable for all resources"
    type                        = map
}

