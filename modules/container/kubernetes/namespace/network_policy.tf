locals {
  network_policy_labels = {
    "app.kubernetes.io/name" = "deny-all-ingress"
    "app.kubernetes.io/component" = "network"
    "app.kubernetes.io/part-of" = var.solution_name
    "app.kubernetes.io/managed-by" = "Terraform"
  }
}

resource kubernetes_network_policy deny_all_ingress {
  count = var.network_policy_enforced ? 1 : 0
  metadata {
    name = "deny-all-ingress"
    namespace = kubernetes_namespace.namespace[0].metadata[0].name
    labels = local.network_policy_labels
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {}
  }
}