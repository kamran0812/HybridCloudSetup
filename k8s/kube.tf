provider "kubernetes" {
  config_context_cluster = "minikube"
}

resource "kubernetes_deployment" "wordpress" {
  metadata{
    name = "wordpress"
  }
  spec{
    replicas = 1
    selector{
      match_labels ={
        env = "production"
        app = "wordpress"
      }
      match_expressions {
        key = "env"
        operator = "In"
        values = ["production"]
      }
    }
    template {
      metadata{
        labels = {
          env = "production"
          region = "IN"
          app = "wordpress"
        }
      }
    spec{
      container {
        image = "wordpress"
        name = "mywp"
      }
    }
    }

  }
}

resource "kubernetes_service" "wordpress" {
  metadata{
    name = "wordpress"
  }
  spec {
    selector = {
        app = kubernetes_deployment.wordpress.spec.0.template.0.metadata[0].labels.app
    }
    port{
      node_port = 30201
      port = 80
      target_port = 80
    }
    type = "NodePort"
  }
}