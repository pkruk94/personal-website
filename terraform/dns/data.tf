data "aws_ssm_parameter" "cloudflare_dns_token" {
  count = var.environment == "prod" ? 1 : 0
  name = "/dns/${var.environment}/cloudflare/dns_api_token"
  with_decryption = true
}

data "aws_ssm_parameter" "cloudfront_domain_name" {
  count = var.environment == "prod" ? 1 : 0
  name = "/infra/${var.environment}/cloudfront/domain_name"
}

data "aws_ssm_parameter" "cloudflare_zone_id" {
  count = var.environment == "prod" ? 1 : 0
  name = "/dns/${var.environment}/cloudflare/cloudflare_zone_id"
}