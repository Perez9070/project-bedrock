#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/deploy_local.sh
cd terraform/bootstrap
terraform init
terraform apply -auto-approve
cd ../
terraform init
terraform apply -auto-approve -var="assets_bucket_suffix=alt-soe-025-1334"

echo "Updating kubeconfig and applying k8s manifests..."
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
kubectl apply -f ../k8s/ --recursive

echo "Done. Run 'kubectl get pods -n retail-app' to check the application."