# ==============================================================================
# AWS CloudFront CDN Distribution (Global Edge Caching & HTTPS)
# ==============================================================================

# Origin Access Control (OAC) for authenticating CloudFront with S3
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-oac"
  description                       = "Origin Access Control for Static Website S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "portfolio" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.domain_name}"
  default_root_object = "index.html"

  aliases = concat([var.domain_name], var.subdomains)

  # Connect to S3 Origin in ap-south-1 using OAC
  origin {
    domain_name              = aws_s3_bucket.portfolio.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.portfolio.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # Default Cache Behavior (Redirect HTTP -> HTTPS)
  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.portfolio.id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    # AWS Managed Caching Policy: Managed-CachingOptimized
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  # SPA / Direct Link Error Routing fallback
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  # PriceClass_200: Includes India (Mumbai, Hyderabad, Delhi, Chennai) + US + Europe + Asia
  # Covered 100% under AWS CloudFront Free Tier (up to 1 TB and 10M requests/month)
  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Free ACM SSL Certificate Configuration (from us-east-1 provider)
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name        = "${var.project_name}-cdn"
    Environment = var.environment
  }
}
