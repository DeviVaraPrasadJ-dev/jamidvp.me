# ==============================================================================
# S3 Static Website Storage (Secured & Private via OAC)
# ==============================================================================

# S3 Bucket for Website Assets
resource "aws_s3_bucket" "portfolio" {
  bucket        = "${var.domain_name}-static-website"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = var.environment
    Domain      = var.domain_name
  }
}

# Keep the S3 Bucket completely private (CloudFront accesses it securely via OAC)
resource "aws_s3_bucket_public_access_block" "portfolio_private" {
  bucket = aws_s3_bucket.portfolio.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Policy: Allow ONLY CloudFront Origin Access Control (OAC) to read objects
resource "aws_s3_bucket_policy" "cloudfront_oac_read" {
  bucket = aws_s3_bucket.portfolio.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.portfolio.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.portfolio.arn
          }
        }
      }
    ]
  })
}

# Helper mapping for standard static website MIME content types
locals {
  mime_types = {
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "json" = "application/json"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "svg"  = "image/svg+xml"
    "ico"  = "image/x-icon"
  }
}

# Automatically upload static files from parent portfolio directory
resource "aws_s3_object" "static_files" {
  for_each = fileset("${path.module}/..", "{*.html,*.css,*.js}")

  bucket       = aws_s3_bucket.portfolio.id
  key          = each.value
  source       = "${path.module}/../${each.value}"
  etag         = filemd5("${path.module}/../${each.value}")
  content_type = lookup(local.mime_types, regex("[^.]+$", each.value), "binary/octet-stream")
}
