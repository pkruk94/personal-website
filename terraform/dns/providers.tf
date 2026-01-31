provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_dns_token.value
}