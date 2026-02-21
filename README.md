Project Bedrock — InnovateMart Scaffold

This repo sets up the basic infra for a retail app using Terraform + EKS, S3 → Lambda asset processing, and GitHub Actions for CI. Think of it like a starter kit—you can run it, tweak it, and build on top.

Region: us-east-1
EKS cluster: project-bedrock-cluster
VPC tag: project-bedrock-vpc
K8s namespace: retail-app
Developer IAM user: bedrock-dev-view
Assets bucket: bedrock-assets-alt-soe-025-1334
Lambda: bedrock-asset-processor
Tags: Project = Bedrock

What’s in here

Terraform → terraform/ (including terraform/bootstrap for remote state).

K8s manifests → k8s/ (super tiny placeholder app + mysql/postgres/redis/rabbitmq stubs).

Lambda → lambda/index.py (logs S3 events, nothing fancy).

Scripts → scripts/ (helpers like deploy_local.sh, generate-grading-json.sh, generate-kubeconfig.sh).

How I run this locally

Bootstrap remote state (only if you haven’t done it yet):

cd terraform/bootstrap
terraform init
terraform apply -auto-approve

Run main Terraform apply (this creates VPC, EKS, S3, Lambda, IAM, etc.):

cd terraform
terraform init
terraform apply -auto-approve -var="assets_bucket_suffix=alt-soe-025-1334"

Update kubeconfig and deploy K8s manifests:

aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
kubectl apply -f k8s/ --recursive
kubectl get pods -n retail-app
Grading JSON (if needed)
cd terraform
terraform output -json > ../grading.json
Important stuff to know

Never check in AWS creds.

The IAM user bedrock-dev-view is read-only + console login scaffolded—change passwords and rotate creds before sharing.

S3 bucket + Terraform backend names have a suffix to avoid collisions. Change assets_bucket_suffix in terraform/variables.tf if you want something else.

Lambda package is built from lambda/ via data "archive_file" in Terraform. Make sure lambda/package.zip is writable.

Quick status check

Terraform files look clean and ready to run.

K8s manifests are minimal but present.

Lambda is a small S3 event logger, works fine for the scaffold.

Scripts just wrap Terraform and kubectl—make sure you have AWS CLI, kubectl, and Terraform installed.