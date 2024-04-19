locals {
  namespace_templates_with_netpol = [for knt in var.kubernetes_namespace_templates : knt if knt.network_policy_enforced]
  namespace_names_with_netpol = [for knt in var.kubernetes_namespace_templates : knt.name if knt.network_policy_enforced]
  namespaces_with_netpol_by_name = zipmap(local.namespace_names_with_netpol, local.namespace_names_with_netpol)
}

resource kubernetes_network_policy this {
  for_each = local.namespaces_with_netpol_by_name
  metadata {
    name = "deny-all-ingress"
    namespace = each.key
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

  depends_on = [ kubernetes_namespace_v1.this ]
}