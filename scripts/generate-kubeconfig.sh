#!/usr/bin/env bash
set -euo pipefail

# Generates a kubeconfig at ./kube/config for the EKS cluster
# Requirements: AWS CLI configured with credentials that can call eks:DescribeCluster

mkdir -p ./kube
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster --kubeconfig ./kube/config

echo "Wrote ./kube/config"
