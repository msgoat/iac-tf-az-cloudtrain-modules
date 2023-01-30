output k8s_namespace_id {
  description = "Unique identifier of the newly created Kubernetes namespace"
  value = var.create_namespace ? kubernetes_namespace.namespace[0].metadata[0].uid : ""
}

output k8s_namespace_name {
  description = "Fully qualified name of the newly created Kubernetes namespace"
  value = var.create_namespace ? kubernetes_namespace.namespace[0].metadata[0].name : var.kubernetes_namespace_name
}