# ==============================================================================
# Terraform Versions & Providers
# ==============================================================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default AWS Provider
provider "aws" {
  region = var.aws_region
}

# CloudFront requires ACM certificates to be created in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
