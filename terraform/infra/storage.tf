resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

resource "aws_s3_bucket" "static_content_bucket" {
  bucket        = "${data.aws_ssm_parameter.static_content_bucket_prefix.value}-${random_string.random_suffix.result}"
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "Static content bucket"
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_content_bucket_crypto_conf" {
  bucket = aws_s3_bucket.static_content_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "static_content_bucket_public_access_block" {
  bucket = aws_s3_bucket.static_content_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "static_content_bucket_policy" {
  bucket = aws_s3_bucket.static_content_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_content_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.static_content_distribution.arn
          }
        }
      }
    ]
  })
}