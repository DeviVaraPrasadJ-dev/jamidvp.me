#!/bin/bash
# ==============================================================================
# Instant Deployment Script for jamidvp.me
# Updates HTML, CSS, JS in S3 and instantly invalidates CloudFront cache.
# ==============================================================================

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

echo "🚀 Starting deployment for jamidvp.me..."

# Check if AWS CLI is configured
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it or use Terraform directly."
    exit 1
fi

BUCKET_NAME="jamidvp.me-static-website"

# Get CloudFront distribution ID from terraform output or AWS CLI if available
if [ -d "$DIR/terraform" ] && [ -f "$DIR/terraform/terraform.tfstate" ]; then
    DIST_ID=$(terraform -chdir="$DIR/terraform" output -raw cloudfront_distribution_id 2>/dev/null || echo "")
fi

if [ -z "$DIST_ID" ]; then
    DIST_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?Aliases.Items!=null && contains(Aliases.Items, 'jamidvp.me')].Id" --output text 2>/dev/null || echo "")
fi

echo "📦 Uploading static files (HTML, CSS, JS) to s3://$BUCKET_NAME..."
aws s3 cp "$DIR/index.html" "s3://$BUCKET_NAME/index.html" --content-type "text/html" --cache-control "max-age=0, no-cache, no-store, must-revalidate"
aws s3 cp "$DIR/style.css" "s3://$BUCKET_NAME/style.css" --content-type "text/css" --cache-control "max-age=86400"
aws s3 cp "$DIR/app.js" "s3://$BUCKET_NAME/app.js" --content-type "application/javascript" --cache-control "max-age=86400"

if [ -n "$DIST_ID" ]; then
    echo "⚡ Invalidating CloudFront edge cache (Distribution: $DIST_ID)..."
    aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*" > /dev/null
    echo "✅ Cache invalidation submitted! Live updates will reflect across all edges in seconds."
else
    echo "⚠️ CloudFront Distribution ID not detected. If this is the initial setup, please run terraform first."
fi

echo "🎉 Deployment complete! Visit https://jamidvp.me"
