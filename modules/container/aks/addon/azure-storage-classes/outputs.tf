output pvc_disk_encryption_set_id {
  description = "Unique identifier of disk encryption set providing the persistent volume encryption"
  value = azurerm_disk_encryption_set.cmk_pvc_encryption.id
}

output pvc_disk_encryption_key_id {
  description = "Unique identifier of key vault key used for the persistent volume encryption"
  value = azurerm_key_vault_key.cmk_pvc_encryption.id
}

output k8s_storage_class_names {
  description = "Names of the added Kubernetes storage classes"
  value = [ kubernetes_storage_class_v1.cmk_csi_standard.metadata[0].name, kubernetes_storage_class_v1.cmk_csi_premium.metadata[0].name ]
}
