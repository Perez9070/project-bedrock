terraform {
  backend "s3" {
    bucket         = "bedrock-terraform-state-alt-soe-025-1334"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true  # ← New way (S3 native locking)
    encrypt        = true
  }
}