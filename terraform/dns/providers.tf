provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_dns_token.value
}

provider "aws" {
  region = "us-east-1"
}