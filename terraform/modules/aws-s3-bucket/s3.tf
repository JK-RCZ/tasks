
resource "aws_kms_key" "this" {
  count                    = var.s3_bucket.s3_encryption_params.enble_encryption ? 1 : 0
  deletion_window_in_days  = var.s3_bucket.s3_encryption_params.deletion_window_in_days
  customer_master_key_spec = var.s3_bucket.s3_encryption_params.customer_master_key_spec
  tags                     = merge(var.common_tags, {Name = "${var.s3_bucket.bucket_name}"})
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count                    = var.s3_bucket.s3_encryption_params.enble_encryption ? 1 : 0
  bucket                   = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      
      kms_master_key_id    = aws_kms_key.this[0].arn
      sse_algorithm        = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  count                    = var.s3_bucket.s3_intelligent_tiering_params.enable_intelligent_tiering ? 1 : 0
  bucket                   = aws_s3_bucket.this.id
  name                     = var.s3_bucket.s3_intelligent_tiering_params.intelligent_tiering_config_name
  
  tiering {
    access_tier            = "DEEP_ARCHIVE_ACCESS"
    days                   = var.s3_bucket.s3_intelligent_tiering_params.days_after_deep_archive_access_allowed
  }
  tiering {
    access_tier            = "ARCHIVE_ACCESS"
    days                   = var.s3_bucket.s3_intelligent_tiering_params.days_after_archive_access_allowed
  }
}

resource "aws_s3_bucket" "this" {
  bucket                   = var.s3_bucket.bucket_name
  tags                     = merge(var.common_tags, {Name = "${var.s3_bucket.bucket_name}"})
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  
  versioning_configuration {
    status = var.s3_bucket.bucket_versioning
  }
}