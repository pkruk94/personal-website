resource "aws_ssm_parameter" "cf_dns_token" {
  name  = "/dns/prod/cloudflare/dns_api_token"
  type  = "SecureString"
  value = var.cf_dns_token

  tags = {
    Environment = "prod"
    ManagedBy  = "terraform--bootstrap"
  }
}

resource "aws_ssm_parameter" "cf_cache_token" {
  name  = "/dns/prod/cloudflare/cache_api_token"
  type  = "SecureString"
  value = var.cf_cache_token

  tags = {
    Environment = "prod"
    ManagedBy  = "terraform-bootstrap"
  }
}

resource "aws_ssm_parameter" "cloudflare_zone_id" {
  name  = "/dns/prod/cloudflare/cloudflare_zone_id"
  type  = "SecureString"
  value = var.cloudflare_zone_id

  tags = {
    Environment = "prod"
    ManagedBy = "terraform-bootstrap"
  }
}

resource "aws_ssm_parameter" "static_content_bucket_prefix" {
  name = "/infra/prod/s3/static_content_bucket_prefix"
  type = "String"
  value = var.bucket_name

  tags = {
    Environment = "prod"
    ManagedBy = "terraform-bootstrap"
  }
}