# ==============================================================================
# Outputs: DNS Records & CloudFront Details
# ==============================================================================

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.portfolio.id
}

output "cloudfront_distribution_id" {
  description = "ID of CloudFront distribution (used for cache invalidations)"
  value       = aws_cloudfront_distribution.portfolio.id
}

output "cloudfront_domain_name" {
  description = "CloudFront default domain name"
  value       = aws_cloudfront_distribution.portfolio.domain_name
}

output "acm_dns_validation_records" {
  description = "CNAME records to add at your domain registrar to validate your free SSL Certificate"
  value = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
}

output "dns_setup_instructions" {
  description = "Summary of DNS records to add at your domain registrar"
  value = <<EOT
--------------------------------------------------------------------------------
DNS CONFIGURATION INSTRUCTIONS FOR YOUR DOMAIN REGISTRAR (${var.domain_name}):
--------------------------------------------------------------------------------
1. SSL CERTIFICATE VALIDATION:
   Add the CNAME records shown above in 'acm_dns_validation_records'.

2. POINT DOMAIN TO CLOUDFRONT:
   - Root Domain (@ / ${var.domain_name}): 
     Add CNAME / ALIAS / ANAME record pointing to: ${aws_cloudfront_distribution.portfolio.domain_name}
   - WWW Subdomain (www.${var.domain_name}): 
     Add CNAME record pointing to: ${aws_cloudfront_distribution.portfolio.domain_name}
--------------------------------------------------------------------------------
EOT
}
