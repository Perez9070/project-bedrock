provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# Kubernetes provider will be configured after the EKS cluster is created using data sources (see k8s resources file).