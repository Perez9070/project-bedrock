# PowerShell script to generate kubeconfig at .\kube\config
# Requirements: AWS CLI configured with credentials that can call eks:DescribeCluster

New-Item -ItemType Directory -Path .\kube -Force | Out-Null
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster --kubeconfig .\kube\config
Write-Host "Wrote .\kube\config"