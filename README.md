# Project Bedrock — InnovateMart Scaffold

This repository provides a starter infrastructure scaffold for a retail application using Terraform, Amazon EKS, S3 → Lambda asset processing, and GitHub Actions for CI. It is designed as a runnable, tweakable base you can extend for real-world workloads.[web:11]

---

## Architecture Overview

- Region: `us-east-1`
- EKS cluster: `project-bedrock-cluster`
- VPC tag: `project-bedrock-vpc`
- Kubernetes namespace: `retail-app`
- Developer IAM user: `bedrock-dev-view` (read-only, console login scaffold)
- Assets bucket: `bedrock-assets-alt-soe-025-1334`
- Lambda function: `bedrock-asset-processor`
- Common tag: `Project = Bedrock`

---

## Repository Structure

- `terraform/`
  - Core infrastructure: VPC, EKS, S3, Lambda, IAM, etc.
  - `terraform/bootstrap/`: Terraform backend and remote state bootstrap.
- `k8s/`
  - Minimal placeholder retail app.
  - Stubs for MySQL, Postgres, Redis, and RabbitMQ.
- `lambda/`
  - `index.py`: Simple S3 event logger used as an asset-processing scaffold.
- `scripts/`
  - `deploy_local.sh`: Helper to apply infrastructure and manifests locally.
  - `generate-grading-json.sh`: Generates grading JSON from Terraform outputs.
  - `generate-kubeconfig.sh`: Helper to configure `kubectl` for the EKS cluster.

---

## Prerequisites

Ensure you have the following tools installed and configured:

- AWS CLI with valid credentials and default region set to `us-east-1`
- Terraform
- kubectl
- (Optional) jq, if you plan to inspect or manipulate JSON outputs[web:13]

---

## Getting Started

### 1. Bootstrap Terraform Remote State

Run this once to set up the remote backend (if not already initialized):

```bash
cd terraform/bootstrap
terraform init
terraform apply -auto-approve
