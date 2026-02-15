terraform {
  backend "s3" {
    bucket         = "bedrock-terraform-state-alt-soe-025-1334"
    key            = "project-bedrock/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bedrock-terraform-locks-alt-soe-025-1334"
    encrypt        = true
  }
}