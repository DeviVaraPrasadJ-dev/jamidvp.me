# ==============================================================================
# AWS Route 53 DNS Configuration (Native CloudFront ALIAS & Auto SSL Validation)
# ==============================================================================

# Public Hosted Zone for jamidvp.me
resource "aws_route53_zone" "primary" {
  name          = var.domain_name
  comment       = "Hosted zone for ${var.domain_name} managed by Terraform"
  force_destroy = false

  tags = {
    Name        = "${var.project_name}-zone"
    Environment = var.environment
  }
}

# Apex / Root Domain IPv4 (A ALIAS -> CloudFront)
resource "aws_route53_record" "apex_a" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}

# Apex / Root Domain IPv6 (AAAA ALIAS -> CloudFront)
resource "aws_route53_record" "apex_aaaa" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}

# WWW Subdomain IPv4 (A ALIAS -> CloudFront)
resource "aws_route53_record" "www_a" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}

# WWW Subdomain IPv6 (AAAA ALIAS -> CloudFront)
resource "aws_route53_record" "www_aaaa" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}

# Automated Route 53 DNS Validation for ACM SSL Certificate
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}
