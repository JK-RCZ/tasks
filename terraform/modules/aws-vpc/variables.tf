
variable "vpc" {
    description                  = "VPC parameters and ebs encryption if necessary"
    type                         = object({
      region                     = string
      tenancy                    = string
      cidr_block                 = string
      name                       = string
      ebs_encryption_params      = object({
        enable_ebs_encryption    = bool
        deletion_window_in_days  = string
        customer_master_key_spec = string
      })
    })
}

variable "common_tags" {
    description                  = "Tags suitable for all resources"
    type                         = map
}
