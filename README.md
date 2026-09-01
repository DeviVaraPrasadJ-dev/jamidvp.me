# DevOps Portfolio - Jami Devi Vara Prasad
🌐 **Domain**: `https://jamidvp.me`

A production-grade, ultra low-cost, automated static portfolio website infrastructure engineered on **AWS (S3 + CloudFront + ACM)** with **Terraform IaC**.

---

## 🏗️ Architecture & Cost Engineering ($0.00 / nil cost)

| Service | Role | Cost / Month (< 1k visits) |
| :--- | :--- | :--- |
| **AWS S3** | Private static storage (OAC enabled) | ~$0.00002 (under free tier) |
| **AWS CloudFront** | Global edge CDN, HTTPS termination | **$0.00** (1 TB / 10M requests free tier) |
| **AWS ACM** | SSL/TLS certificates (`jamidvp.me` & `www.jamidvp.me`) | **$0.00** (100% Free) |
| **External DNS** | Free DNS at Registrar / Cloudflare DNS | **$0.00** (No Route 53 $0.50 fee) |
| **Total Cost** | | **$0.00 / Month** |

---

## 📁 Project Structure

```text
portfolio/
├── index.html              # Portfolio markup (Responsive, interactive)
├── style.css               # Styling & Dark theme
├── app.js                  # Dynamic terminal & FormSubmit handler
├── deploy.sh               # ⚡ 1-click update script (Sync + Cache Invalidation)
└── terraform/              # 🏛️ Infrastructure as Code
    ├── versions.tf         # AWS Provider & multi-region config
    ├── variables.tf        # Configurable domain and project parameters
    ├── terraform.tfvars    # Domain name (jamidvp.me)
    ├── s3.tf               # Private S3 Bucket with Origin Access Control (OAC)
    ├── acm.tf              # Free ACM SSL Certificate
    ├── cloudfront.tf       # CloudFront CDN with HTTPS redirect
    └── outputs.tf          # DNS records and distribution IDs
```

---

## 🚀 Initial Deployment (Step-by-Step)

### 1. Purchase Your Domain
Purchase **`jamidvp.me`** at your preferred registrar (Namecheap, Porkbun, Cloudflare Registrar, Hostinger, GoDaddy).

### 2. Configure AWS Credentials
Ensure you have your AWS Access Key configured:
```bash
aws configure
# Or export AWS_ACCESS_KEY_ID="..." and AWS_SECRET_ACCESS_KEY="..."
```

### 3. Deploy Infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 4. Configure DNS at Your Domain Registrar
Terraform outputs the exact DNS records you need:
1. **SSL Validation CNAME**: Add the CNAME record outputted under `acm_dns_validation_records` in your registrar's DNS settings.
2. **Domain Points to CloudFront**:
   - `CNAME` for `www` $\rightarrow$ `<your-cloudfront-domain>.cloudfront.net`
   - `ALIAS` / `ANAME` / `CNAME flattening` for `@` (root) $\rightarrow$ `<your-cloudfront-domain>.cloudfront.net`

---

## ✏️ Making Future HTML / Code Changes

Whenever you edit `index.html`, `style.css`, or `app.js`, deploy your changes instantly using either:

### Method A: Fast 1-Click Script (Recommended)
```bash
./deploy.sh
```
*This uploads the updated files directly to S3 and invalidates the CloudFront cache. Your edits go live worldwide in seconds.*

### Method B: Terraform Apply
```bash
cd terraform
terraform apply -auto-approve
```
