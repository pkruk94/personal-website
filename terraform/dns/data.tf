data "aws_ssm_parameter" "cloudflare_dns_token" {
  name = "/dns/prod/cloudflare/dns_api_token"
  with_decryption = true
}

data "aws_ssm_parameter" "cloudfront_domain_name" {
  name = "/infra/prod/cloudfront/domain_name"
}

data "aws_ssm_parameter" "cloudflare_zone_id" {
  name = "/dns/prod/cloudflare/cloudflare_zone_id"
}