# create a Kubernetes secret with the username and the password of the Grafana admin user
resource kubernetes_secret grafana {
  type = "Opaque"
  metadata {
    name = "grafana-admin"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      "app.kubernetes.io/name" = "grafana"
      "app.kubernetes.io/component" = "secret"
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  # we are explicitly using binary_data with base64encode() to prevent sensitive data from showing up in terraform state
  binary_data = {
    admin-user = base64encode(random_string.admin.result)
    admin-password = base64encode(random_password.admin.result)
  }
}