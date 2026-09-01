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

output "route53_nameservers" {
  description = "AWS Route 53 Nameservers to set in GoDaddy"
  value       = aws_route53_zone.primary.name_servers
}

output "route53_setup_instructions" {
  description = "Instructions to point GoDaddy domain to Route 53"
  value       = <<EOT
--------------------------------------------------------------------------------
GODADDY NAMESERVER SETUP INSTRUCTIONS:
--------------------------------------------------------------------------------
1. Log in to GoDaddy -> Domain Portfolio -> jamidvp.me -> DNS -> Nameservers.
2. Click "Change Nameservers" -> Select "I'll use my own nameservers".
3. Enter the 4 AWS Nameservers listed in 'route53_nameservers'.
4. Save changes. Route 53 will now manage all DNS with native CloudFront aliases!
--------------------------------------------------------------------------------
EOT
}
