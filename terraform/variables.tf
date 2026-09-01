# ==============================================================================
# Variables Configuration
# ==============================================================================

variable "aws_region" {
  type        = string
  description = "AWS region for standard resources (S3 bucket, etc.)"
  default     = "ap-south-1"
}

variable "domain_name" {
  type        = string
  description = "Primary custom domain name"
  default     = "jamidvp.me"
}

variable "subdomains" {
  type        = list(string)
  description = "Additional subdomain aliases (e.g. www.jamidvp.me)"
  default     = ["www.jamidvp.me"]
}

variable "project_name" {
  type        = string
  description = "Project name tag"
  default     = "devops-portfolio"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "production"
}
