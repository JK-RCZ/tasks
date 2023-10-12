variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
}
variable "tags" {
    description = "Tags mapping"
    type        = map
    default     = {
        Name        = "SuperVPC"
        Environment = "Dev"
        Project     = "Mouse"
    }
}