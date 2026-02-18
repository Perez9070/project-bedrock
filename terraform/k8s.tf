// Configure Kubernetes provider from the created EKS cluster
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Namespace
resource "kubernetes_namespace_v1" "retail_app" {
  metadata {
    name = "retail-app"
    labels = {
      app = "retail"
    }
  }
}

# RBAC: bind the IAM-mapped group to view role so bedrock-dev-view can `kubectl get pods -n retail-app`
resource "kubernetes_cluster_role_binding_v1" "bedrock_dev_view_binding" {
  metadata { name = "bedrock-dev-view-binding" }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    kind      = "Group"
    name      = "bedrock-viewers"
    api_group = "rbac.authorization.k8s.io"
  }
}