resource "aws_ssm_parameter" "cf_dns_token" {
  count = var.environment == "prod" ? 1 : 0
  name  = "/dns/${var.environment}/cloudflare/dns_api_token"
  type  = "SecureString"
  value = var.cf_dns_token

  tags = merge(local.common_tags, {
    ManagedBy = "terraform-bootstrap"
  })
}

resource "aws_ssm_parameter" "cf_cache_token" {
  count = var.environment == "prod" ? 1 : 0
  name  = "/dns/${var.environment}/cloudflare/cache_api_token"
  type  = "SecureString"
  value = var.cf_cache_token

  tags = merge(local.common_tags, {
    ManagedBy = "terraform-bootstrap"
  })
}

resource "aws_ssm_parameter" "cloudflare_zone_id" {
  count = var.environment == "prod" ? 1 : 0
  name  = "/dns/${var.environment}/cloudflare/cloudflare_zone_id"
  type  = "SecureString"
  value = var.cloudflare_zone_id

  tags = merge(local.common_tags, {
    ManagedBy = "terraform-bootstrap"
  })
}

resource "aws_ssm_parameter" "static_content_bucket_prefix" {
  name  = "/infra/${var.environment}/s3/static_content_bucket_prefix"
  type  = "String"
  value = "${var.bucket_name}-${var.environment}"

  tags = merge(local.common_tags, {
    ManagedBy = "terraform-bootstrap"
  })
}