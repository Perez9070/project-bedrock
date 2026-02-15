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

Quick start (local)
1. Install and configure AWS CLI with an admin-capable profile for initial run.
2. From repository root:
   - Bootstrap remote state (creates S3 + DynamoDB):
     cd terraform/bootstrap && terraform init && terraform apply -auto-approve
   - Deploy the infrastructure:
     cd .. && terraform init && terraform apply -auto-approve
   - Generate grading file (required by grader):
     terraform output -json > grading.json
3. Verify cluster and app:
   - aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
   - kubectl get pods -n retail-app

GitHub Actions (CI/CD)
- A workflow is included at `.github/workflows/terraform.yml`.
- Configure repository secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` (us-east-1).
- PR -> runs `terraform plan`. Merge to `main` -> runs `terraform apply` + deploys k8s manifests and commits `grading.json`.

What I scaffolded for you
- Terraform: `terraform/bootstrap` (remote-state bootstrap) and root Terraform for VPC, EKS, IAM user, S3 + Lambda, Kubernetes resources (placeholder retail-app).
- Lambda code: `lambda/index.py` (simple logger).
- Kubernetes placeholder app manifests under `k8s/`.
- GitHub Actions workflow to plan/apply and commit `grading.json`.

Next steps I can do for you
1. Run `terraform apply` here (I will need your AWS creds) — or guide you step-by-step while you run locally.
2. Add bonus features (RDS / ALB + ACM) if you want extra marks.

Notes & warnings
- Do **not** commit AWS credentials to this repo.
- This scaffold aims to meet all core requirements; review the `terraform/*.tf` files before applying.

Contact / Help
- Tell me if you want me to run `terraform apply` here, or if you want me to push to your GitHub repo (paste URL).