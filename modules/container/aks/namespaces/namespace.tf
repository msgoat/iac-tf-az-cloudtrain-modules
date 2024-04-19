locals {
  namespace_names = [for knt in var.kubernetes_namespace_templates : knt.name]
  namespaces_by_name = zipmap(local.namespace_names, var.kubernetes_namespace_templates)
}

# create a namespace for hello application
resource kubernetes_namespace_v1 this {
  for_each = local.namespaces_by_name
  metadata {
    name = each.key
    labels = {
      "app.kubernetes.io/name" = each.key
      "app.kubernetes.io/component" = "namespace"
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
}
