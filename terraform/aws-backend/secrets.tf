resource "aws_ssm_parameter" "cf_dns_token" {
  name  = "/infra/prod/cloudflare/dns_api_token"
  type  = "SecureString"
  value = var.cf_dns_token

  tags = {
    Enviroment = "prod"
    ManagedBy = "terraform--bootstrap"
  }
}

resource "aws_ssm_parameter" "cf_cache_token" {
  name  = "/infra/prod/cloudflare/cache_api_token"
  type  = "SecureString"
  value = var.cf_cache_token

  tags = {
    Enviroment = "prod"
    ManagedBy = "terraform--bootstrap"
  }
}

resource "aws_ssm_parameter" "cloudflare_zone_id" {
  name  = "/infra/prod/cloudflare/cloudflare_zone_id"
  type  = "SecureString"
  value = var.cloudflare_zone_id
}