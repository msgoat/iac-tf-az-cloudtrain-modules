locals {
  kv_key_name = "key-${local.aks_cluster_name}-pvc"
}

# create a cluster-specific customer managed key for persistent volume claim encryption
resource azurerm_key_vault_key cmk_pvc_encryption {
  name = local.kv_key_name
  key_vault_id = var.key_vault_id
  key_type = "RSA"
  key_size = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  tags = merge({"Name" = local.kv_key_name}, local.module_common_tags)
}
