resource "aws_acm_certificate" "ssl_certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.us_east_1
}

resource "cloudflare_dns_record" "ssl_certificate_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_ssm_parameter.cloudflare_zone_id.value
  name    = each.value.name
  content = each.value.record
  type    = each.value.type
  ttl     = 60
}

resource "aws_acm_certificate_validation" "ssl_certificate_validation" {
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.ssl_certificate_validation_record : trimsuffix(record.name, ".")]

  timeouts {
    create = "5m"
  }
}