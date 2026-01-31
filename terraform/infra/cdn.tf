resource "aws_cloudfront_origin_access_control" "static_content_origin_access_control" {
  name                              = "static-content-origin-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "static_content_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_content_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.static_content_origin_access_control.id
    origin_id                = "S3-${aws_s3_bucket.static_content_bucket.id}"
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.environment == "prod" ? [var.domain_name] : []

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.static_content_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.environment == "prod" ?
      aws_acm_certificate_validation.ssl_certificate_validation.certificate_arn[0] : null
    cloudfront_default_certificate = var.environment == "prod" ? false : true
    ssl_support_method             = var.environment == "prod" ? "sni-only" : null
    minimum_protocol_version       = var.environment == "prod" ? "TLSv1.2_2021" : null
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}