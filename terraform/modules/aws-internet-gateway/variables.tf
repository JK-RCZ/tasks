variable "vpc_id" {
    description                 = "VPC ID to stick to"
    type                        = string
}

variable "igw_name" {
    description                 = "IGW name"
    type                        = string
}

variable "common_tags" {
    description                 = "Tags suitable for all resources"
    type                        = map
}