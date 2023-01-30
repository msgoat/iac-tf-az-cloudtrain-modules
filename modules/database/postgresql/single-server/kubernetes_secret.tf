# create a Kubernetes secret with the username and the password of the PostgreSQL admin user in each given namespace
resource kubernetes_secret postgres {
  count = var.kubernetes_secret_enabled ? length(var.kubernetes_namespace_names) : 0
  type = "Opaque"
  metadata {
    name = azurerm_postgresql_server.postgres.name
    namespace = var.kubernetes_namespace_names[count.index]
    labels = {
      "app.kubernetes.io/name" = azurerm_postgresql_server.postgres.name
      "app.kubernetes.io/component" = "secret"
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  # we are explicitly using binary_data with base64encode() to prevent sensitive data from showing up in terraform state
  binary_data = {
    postgresql-user = base64encode("${random_string.db_user.result}@${azurerm_postgresql_server.postgres.name}")
    postgresql-password = base64encode(random_password.db_password.result)
  }
}