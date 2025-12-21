resource "aws_ssm_parameter" "static_content_bucket_fullname" {
  name = "/infra/prod/s3/bucket_name"
  type = "String"
  value = aws_s3_bucket.static_content_bucket.bucket
}

resource "aws_ssm_parameter" "cloudfront_distribution_id" {
  name = "/infra/prod/cloudfront/distribution_id"
  type = "String"
  value = aws_cloudfront_distribution.static_content_distribution.id

  tags = {
    Name = "CloudFront Distribution ID"
  }
}

resource "aws_ssm_parameter" "cloudfront_domain_name" {
  name  = "/infra/prod/cloudfront/domain_name"
  type  = "String"
  value = aws_cloudfront_distribution.static_content_distribution.domain_name

  tags = {
    Name = "CloudFront Domain Name"
  }
}