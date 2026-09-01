# ==============================================================================
# AWS Certificate Manager (ACM) - Free SSL/TLS Certificate
# ==============================================================================

# Request a free public SSL certificate in us-east-1 (required for CloudFront)
resource "aws_acm_certificate" "cert" {
  provider                  = aws.us_east_1
  domain_name               = var.domain_name
  subject_alternative_names = var.subdomains
  validation_method         = "DNS"

  tags = {
    Name        = "${var.project_name}-ssl-cert"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}
