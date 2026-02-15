output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_id
}

output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.project_bedrock.id
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "bedrock_dev_access_key_id" {
  value     = aws_iam_access_key.bedrock_dev_key.id
  sensitive = true
}

output "bedrock_dev_secret_access_key" {
  value     = aws_iam_access_key.bedrock_dev_key.secret
  sensitive = true
}

output "bedrock_dev_console_password" {
  value     = aws_iam_user_login_profile.bedrock_dev_console.password
  sensitive = true
}

output "bedrock_dev_console_signin_url" {
  value = "https://console.aws.amazon.com/console/home?region=${var.region}#/signin?account=${data.aws_caller_identity.current.account_id}"
  description = "Sign-in URL for AWS console (use the IAM username and password output above)."
}