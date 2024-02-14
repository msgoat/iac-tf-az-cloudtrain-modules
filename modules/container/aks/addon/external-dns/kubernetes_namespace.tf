# create a namespace for ExternalDNS
resource kubernetes_namespace external_dns {
  count = var.kubernetes_namespace_owned ? 1 : 0
  metadata {
    name = var.kubernetes_namespace_name
    labels = {
      "app.kubernetes.io/component" = "external-dns"
      "app.kubernetes.io/instance" = var.helm_release_name
      "app.kubernetes.io/managed-by" = "Terraform"
      "app.kubernetes.io/name" = var.kubernetes_namespace_name
      "app.kubernetes.io/part-of" = var.helm_release_name
    }
  }
}
