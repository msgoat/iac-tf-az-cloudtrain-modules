resource "kubernetes_ingress_v1" "nginx" {
  count = var.load_balancer_strategy == "INGRESS_VIA_AGW" ? 1 : 0
  metadata {
    name      = "ingress-nginx-controller-agic"
    namespace = var.kubernetes_namespace_name
    labels = {
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/instance"   = "ingress-nginx"
      "app.kubernetes.io/managed-by" = "Terraform"
      "app.kubernetes.io/name"       = "ingress-nginx"
      "app.kubernetes.io/part-of"    = "ingress-nginx"
    }
    annotations = {
      "cert-manager.io/cluster-issuer" : var.cert_manager_issuer_name
    }
  }
  spec {
    ingress_class_name = "azure-application-gateway"
    rule {
      host = data.azurerm_dns_zone.given.name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "ingress-nginx-controller"
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [data.azurerm_dns_zone.given.name]
      secret_name = "ingress-nginx-agic-tls"
    }
  }

  depends_on = [helm_release.nginx]
}
