resource kubernetes_storage_class_v1 cmk_csi_standard {
  count = var.addon_enabled ? 1 : 0
  metadata {
    name = "cmk-csi-standard"
    labels = {
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  storage_provisioner = "disk.csi.azure.com"
  parameters = {
    skuname = "StandardSSD_LRS"
    kind = "managed"
    diskEncryptionSetID = var.aks_disk_encryption_set_id
  }
  volume_binding_mode = "WaitForFirstConsumer"
}

resource kubernetes_storage_class_v1 cmk_csi_premium {
  count = var.addon_enabled ? 1 : 0
  metadata {
    name = "cmk-csi-premium"
    labels = {
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  storage_provisioner = "disk.csi.azure.com"
  parameters = {
    skuname = "Premium_LRS"
    kind = "managed"
    diskEncryptionSetID = var.aks_disk_encryption_set_id
  }
  volume_binding_mode = "WaitForFirstConsumer"
}
