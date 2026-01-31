resource "aws_ssm_parameter" "static_content_bucket_fullname" {
  name  = "/infra/${var.environment}/s3/bucket_name"
  type  = "String"
  value = aws_s3_bucket.static_content_bucket.bucket

  tags = merge(local.common_tags, {
    Name = "Static content bucket name"
  })
}

resource "aws_ssm_parameter" "cloudfront_distribution_id" {
  name  = "/infra/${var.environment}/cloudfront/distribution_id"
  type  = "String"
  value = aws_cloudfront_distribution.static_content_distribution.id

  tags = merge(local.common_tags, {
    Name = "CloudFront Distribution ID"
  })
}

resource "aws_ssm_parameter" "cloudfront_domain_name" {
  name  = "/infra/${var.environment}/cloudfront/domain_name"
  type  = "String"
  value = aws_cloudfront_distribution.static_content_distribution.domain_name

  tags = merge(local.common_tags, {
    Name = "CloudFront Domain Name"
  })
}