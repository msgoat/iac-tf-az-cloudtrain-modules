locals {
  namespace_names = toset(var.kubernetes_namespace_names)
}

# create a Kubernetes secret with the username and the password of the PostgreSQL admin user in each given namespace
resource kubernetes_secret insights {
  for_each = local.namespace_names
  type = "Opaque"
  metadata {
    name = azurerm_application_insights.insights.name
    namespace = each.value
    labels = {
      "app.kubernetes.io/name" = azurerm_application_insights.insights.name
      "app.kubernetes.io/component" = "secret"
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  # we are explicitly using binary_data with base64encode() to prevent sensitive data from showing up in terraform state
  binary_data = {
    instrumentation-key = base64encode(azurerm_application_insights.insights.instrumentation_key)
    connection-string = base64encode(azurerm_application_insights.insights.connection_string)
  }
}