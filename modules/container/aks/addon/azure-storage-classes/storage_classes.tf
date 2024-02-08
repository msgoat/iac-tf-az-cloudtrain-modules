resource "kubernetes_storage_class_v1" "cmk_csi_standard" {
  metadata {
    name = "cmk-csi-standard"
    labels = {
      "app.kubernetes.io/part-of"    = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  storage_provisioner = "disk.csi.azure.com"
  parameters = {
    skuname             = "StandardSSD_LRS"
    kind                = "managed"
    diskEncryptionSetID = data.azurerm_kubernetes_cluster.given.disk_encryption_set_id
  }
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class_v1" "cmk_csi_premium" {
  metadata {
    name = "cmk-csi-premium"
    labels = {
      "app.kubernetes.io/part-of"    = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  storage_provisioner = "disk.csi.azure.com"
  parameters = {
    skuname             = "Premium_LRS"
    kind                = "managed"
    diskEncryptionSetID = data.azurerm_kubernetes_cluster.given.disk_encryption_set_id
  }
  volume_binding_mode = "WaitForFirstConsumer"
}
