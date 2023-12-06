variable "s3_bucket" {
    description                                  = "S3 bucket parameters"
    type                                         = object({
      aws_region                                 = string
      bucket_name                                = string
      acl_type                                   = string
    })
}

variable "common_tags" {
    description                                  = "Tags suitable for all resources"
    type                                         = map
}