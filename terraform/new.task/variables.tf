variable "region" {
    description = "AWS Region"
    
}
/*variable "modules" {
    description = "applied modules data"
    type = list(object({
      path = string
      specific_tag = string      
    }))
}*/
variable "vpc_cidr_block" {
    description = "VPC CIDR block"
    
}

variable "common_tags" {
    description = "common tags for all resourses"
    type = object({
      Environment = string
      Project = string
    })
}
