locals {
  namespace_labels = {
    "app.kubernetes.io/name" = var.kubernetes_namespace_name
    "app.kubernetes.io/component" = "namespace"
    "app.kubernetes.io/part-of" = var.solution_name
    "app.kubernetes.io/managed-by" = "Terraform"
    "istio-injection" = var.istio_injection_enabled ? "enabled" : "disabled"
  }
}

# create a namespace for hello application
resource kubernetes_namespace namespace {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.kubernetes_namespace_name
    labels = local.namespace_labels
  }
}
