provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
  alias = "us_east_1"
}

data "aws_ssm_parameter" "cloudflare_dns_token" {
  name = "/infra/prod/cloudflare/dns_api_token"
  with_decryption = true
}

provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_dns_token
}