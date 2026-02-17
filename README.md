# Project Bedrock — InnovateMart (scaffold)

Summary
- Purpose: Terraform + EKS infra, retail-app placeholder, S3 → Lambda asset processor, CloudWatch logging, and GitHub Actions CI for plan/apply.
- Region: `us-east-1`
- EKS cluster name: `project-bedrock-cluster`
- VPC tag: `project-bedrock-vpc`
- Namespace: `retail-app`
- Developer IAM user: `bedrock-dev-view`
- Assets bucket: `bedrock-assets-alt-soe-025-1334`
- Lambda: `bedrock-asset-processor`
- All resources tagged: `Project = Bedrock`

# Yo — quick repo notes (what I did and how to run it)

Short version
- This repo sets up infra with Terraform (VPC, EKS, IAM, S3 + Lambda), a tiny placeholder app in Kubernetes under `k8s/`, and a simple Lambda in `lambda/index.py` that logs S3 uploads. There's also a few helper scripts in `scripts/`.

What lives here
- Terraform: `terraform/` (including `terraform/bootstrap` for remote state).
- K8s manifests: `k8s/` (UI + mysql/postgres/redis/rabbitmq placeholders).
- Lambda: `lambda/index.py` (basic S3 event logger).
- Scripts: `scripts/` for local helpers like `deploy_local.sh`, `generate-grading-json.sh`, and `generate-kubeconfig.sh`.

Quick local run (how I run it)
1) Bootstrap remote state (only if you haven't):

```bash
cd terraform/bootstrap
terraform init
terraform apply -auto-approve
```

2) From repo root, run the main apply (this will create VPC, EKS, S3, Lambda, IAM etc):

```bash
cd terraform
terraform init
terraform apply -auto-approve -var="assets_bucket_suffix=alt-soe-025-1334"
```

3) Update kubeconfig and apply k8s manifests (or use `scripts/deploy_local.sh`):

```bash
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
kubectl apply -f k8s/ --recursive
kubectl get pods -n retail-app
```

Grading JSON (if you need to generate it locally)

```bash
cd terraform
terraform output -json > ../grading.json
```

Important notes / gotchas (read this)
- Don't check in AWS credentials anywhere.
- The IAM user `bedrock-dev-view` is created with ReadOnly access and a console login is scaffolded; change passwords and rotate creds before sharing.
- The S3 bucket and terraform backend names include a suffix to avoid collisions; adjust `assets_bucket_suffix` in `terraform/variables.tf` if you want a different name.
- The lambda package is built from `lambda/` via `data "archive_file"` in Terraform; make sure `lambda/package.zip` is writable by Terraform runs.

What I checked quickly (status)
- Terraform files: look consistent and ready to run from this repo (backend uses S3 + DynamoDB).
- Kubernetes manifests and Terraform k8s provider are present and minimal for grading.
- Lambda `index.py` is a tiny S3-event logger and is OK for the scaffold.
- Scripts are simple wrappers around `terraform` and `kubectl` — they assume you have the AWS CLI, kubectl, and Terraform installed.

If you want me to do this for you
- I can run `terraform apply` here if you want (you'd need to provide credentials or run with a profile). Or I can walk you through each command while you run them locally.

Next steps I suggest
- If you're submitting this for grading: run `scripts/generate-grading-json.sh` and commit `grading.json`.
- If you want extra features (RDS, ALB, ACM), tell me which and I'll add them.

— If you want the tone/names changed to sound more like you, tell me how you usually write and I'll match it.
