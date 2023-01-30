locals {
  network_policy_namespaces = toset( var.network_policy_enforced ? var.kubernetes_namespace_names : [])
}

resource kubernetes_network_policy deny_all_ingress {
  for_each = local.network_policy_namespaces
  metadata {
    name = "deny-all-ingress"
    namespace = each.value
    labels = {
      "app.kubernetes.io/name" = "deny-all-ingress"
      "app.kubernetes.io/component" = "network"
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
      }
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {}
  }

  depends_on = [ kubernetes_namespace.namespace ]
}