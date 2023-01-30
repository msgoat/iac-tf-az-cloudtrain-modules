# create a Kubernetes secret with the username and the password of the Elasticsearch user in each given namespace
resource kubernetes_secret elasticsearch {
  type = "Opaque"
  metadata {
    name = "${var.elasticsearch_cluster_name}-master-credentials"
    namespace = var.kubernetes_namespace_name
    labels = {
      "app.kubernetes.io/name" = var.elasticsearch_cluster_name
      "app.kubernetes.io/component" = "secret"
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  # we are explicitly using binary_data with base64encode() to prevent sensitive data from showing up in terraform state
  binary_data = {
    username = base64encode(local.es_default_user)
    password = base64encode(random_password.password.result)
  }
}