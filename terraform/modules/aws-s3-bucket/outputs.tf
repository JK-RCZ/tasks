output "s3_data" {
    description               = "s3 main data"
    value                     = {
        name                  = aws_s3_bucket.this.tags.Name,
        id                    = aws_s3_bucket.this.id
    }
}
