module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" 

  name    = var.cluster_name
  kubernetes_version = "1.34"

  vpc_id                   = aws_vpc.project_bedrock.id
  subnet_ids               = aws_subnet.private[*].id
  control_plane_subnet_ids = aws_subnet.private[*].id

  eks_managed_node_groups = {
    default = {
      desired_size   = 2 # was 1
      min_size       = 1 # keep as 1 for flexibility, or set to 2
      max_size       = 2 # allow scaling up to 2 (or 3 if you want headroom)
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 20
          kubernetes_version = "1.34"

      tags = {
        Name    = "default"
        Project = "Bedrock"
      }
    }
  }


  enable_irsa = true

# cluster_log_types = ["api", "audit", "authenticator"]
 
  tags = {
    Project = "Bedrock"
  }


}
