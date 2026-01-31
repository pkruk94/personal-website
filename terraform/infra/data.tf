data "aws_ssm_parameter" "cloudflare_zone_id" {
  name = "/dns/prod/cloudflare/cloudflare_zone_id"
}

data "aws_ssm_parameter" "static_content_bucket_prefix" {
  name = "/infra/prod/s3/static_content_bucket_prefix"
}