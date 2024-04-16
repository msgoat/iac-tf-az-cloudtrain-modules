output "k8s_storage_class_names" {
  description = "Names of the added Kubernetes storage classes"
  value       = [kubernetes_storage_class_v1.cmk_csi_standard.metadata[0].name, kubernetes_storage_class_v1.cmk_csi_premium.metadata[0].name]
}

output default_k8s_storage_class_name {
  description = "Name of the default Kubernetes storage class to be used for persistent volume claims"
  value = kubernetes_storage_class_v1.cmk_csi_premium.metadata[0].name
}