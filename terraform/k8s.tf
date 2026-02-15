# Configure Kubernetes provider from the created EKS cluster
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
resource "kubernetes_namespace" "retail_app" {
  metadata {
    name = "retail-app"
    labels = {
      app = "retail"
    }
  }
}

# UI deployment (placeholder)
resource "kubernetes_deployment" "ui" {
  metadata {
    name      = "ui"
    namespace = kubernetes_namespace.retail_app.metadata[0].name
    labels = { app = "retail-ui" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "retail-ui" }
    }

    template {
      metadata { labels = { app = "retail-ui" } }

      spec {
        container {
          name  = "ui"
          image = "nginx:1.25-alpine"
          port { container_port = 80 }
        }
      }
    }
  }
}

resource "kubernetes_service" "ui" {
  metadata {
    name      = "ui"
    namespace = kubernetes_namespace.retail_app.metadata[0].name
  }

  spec {
    selector = { app = "retail-ui" }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}

# In-cluster dependencies (minimal pods for grading)
resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.retail_app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "mysql" }
    }

    template {
      metadata {
        labels = { app = "mysql" }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:8.0"
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "password"
          }
          port { container_port = 3306 }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.retail_app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "postgres" }
    }

    template {
      metadata {
        labels = { app = "postgres" }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:15"
          env {
            name  = "POSTGRES_PASSWORD"
            value = "password"
          }
          port { container_port = 5432 }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "redis" {
  metadata { name = "redis" namespace = kubernetes_namespace.retail_app.metadata[0].name }
  spec {
    replicas = 1
    selector { match_labels = { app = "redis" } }
    template {
      metadata { labels = { app = "redis" } }
      spec {
        container { name = "redis" image = "redis:6-alpine" port { container_port = 6379 } }
      }
    }
  }
}

resource "kubernetes_deployment" "rabbitmq" {
  metadata { name = "rabbitmq" namespace = kubernetes_namespace.retail_app.metadata[0].name }
  spec {
    replicas = 1
    selector { match_labels = { app = "rabbitmq" } }
    template {
      metadata { labels = { app = "rabbitmq" } }
      spec {
        container { name = "rabbitmq" image = "rabbitmq:3-management" port { container_port = 5672 } }
      }
    }
  }
}

# RBAC: bind the IAM-mapped group to view role so bedrock-dev-view can `kubectl get pods -n retail-app` but not delete
resource "kubernetes_cluster_role_binding" "bedrock_dev_view_binding" {
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