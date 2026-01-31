resource "cloudflare_dns_record" "website" {
  count = var.environment == "prod" ? 1 : 0
  zone_id = data.aws_ssm_parameter.cloudflare_zone_id[0].value
  name = "@"
  content = data.aws_ssm_parameter.cloudfront_domain_name[0].value
  type = "CNAME"
  ttl = 300
  proxied = false
}