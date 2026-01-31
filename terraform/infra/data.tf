data "aws_ssm_parameter" "cloudflare_zone_id" {
  name = "/infra/prod/cloudflare/cloudflare_zone_id"
}