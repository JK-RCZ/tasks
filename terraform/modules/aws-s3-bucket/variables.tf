
variable "s3_bucket" {
    description                                  = "S3 bucket parameters"
    type                                         = object({
      bucket_name                                = string
      s3_encryption_params                       = object({
        enble_encryption                         = bool
        deletion_window_in_days                  = string
        customer_master_key_spec                 = string
      })
      s3_intelligent_tiering_params              = object({
        enable_intelligent_tiering               = bool
        intelligent_tiering_config_name          = string  
        days_after_deep_archive_access_allowed   = string
        days_after_archive_access_allowed        = string
      })
    })
}

variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}

