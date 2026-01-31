resource "cloudflare_dns_record" "website" {
  zone_id = data.aws_ssm_parameter.cloudflare_zone_id.value
  name = "@"
  content = data.aws_ssm_parameter.cloudfront_domain_name.value
  type = "CNAME"
  ttl = 300
  proxied = false
}