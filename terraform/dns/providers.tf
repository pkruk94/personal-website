provider "cloudflare" {
  api_token = try(data.aws_ssm_parameter.cloudflare_dns_token[0].value, "default")
}

provider "aws" {
  region = "us-east-1"
}