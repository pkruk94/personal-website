data "aws_ssm_parameter" "cloudflare_zone_id" {
  count = var.environment == "prod" ? 1 : 0
  name  = "/dns/${var.environment}/cloudflare/cloudflare_zone_id"
}

data "aws_ssm_parameter" "static_content_bucket_prefix" {
  name = "/infra/${var.environment}/s3/static_content_bucket_prefix"
}