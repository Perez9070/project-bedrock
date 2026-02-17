module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.31"

  cluster_name    = var.cluster_name
  cluster_version = "1.34"

  vpc_id                   = aws_vpc.project_bedrock.id
  subnet_ids               = aws_subnet.private[*].id
  control_plane_subnet_ids = aws_subnet.private[*].id

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 2
      instance_types = [var.instance_type]
    }
  }

  enable_irsa = true

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = {
    Project = "Bedrock"
  }


}
