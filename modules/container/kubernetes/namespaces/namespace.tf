locals {
  namespace_names = toset(var.kubernetes_namespace_names)
}

# create a namespace for hello application
resource kubernetes_namespace namespace {
  for_each = local.namespace_names
  metadata {
    name = each.value
    labels = {
      "app.kubernetes.io/name" = each.value
      "app.kubernetes.io/component" = "namespace"
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
      "istio-injection" = var.istio_injection_enabled ? "enabled" : "disabled"
    }
  }
}
