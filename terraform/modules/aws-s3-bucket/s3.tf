
resource "aws_s3_bucket" "this" {
  provider = var.s3_bucket.aws_region
  bucket   = var.s3_bucket.bucket_name
  acl      = var.s3_bucket.acl_type
  tags     = merge(var.common_tags, {Name = "${var.s3_bucket.bucket_name}"})
}