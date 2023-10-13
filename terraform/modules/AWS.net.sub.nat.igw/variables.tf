/*variable "region" {
    description = "AWS region"
}
variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
}
variable "vpc_name_tag" {
    description = "Specific VPC tag"
}*/

variable "vpc_parameters" {
    description = "Variables for VPC"
    type = object(
      {
      region = string
      vpc_cidr_block = string
      vpc_name_tag = string
      }
    )
}

variable "common_tags" {
    description = "Tags suitable for all resources"
    type        = map
}

variable "subnets" {
    description = "list of subnets"
    type = list(object({
      name = string
      public = bool
      cidr_block = string
      availability_zone = string
    }))
  
}