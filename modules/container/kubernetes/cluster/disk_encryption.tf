locals {
  kv_key_name = "key-${var.region_code}-${var.solution_fqn}-${var.cluster_name}-aks"
  des_name = "des-${var.region_code}-${var.solution_fqn}-${var.cluster_name}-aks"
}

# create a cluster-specific customer managed key for disk encryption
resource azurerm_key_vault_key cmk_disk_encryption {
  count = var.aks_disk_encryption_enabled ? 1 : 0
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

# create an instance of a disk encryption set
resource azurerm_disk_encryption_set cmk_disk_encryption {
  count = var.aks_disk_encryption_enabled ? 1 : 0
  name = local.des_name
  resource_group_name = var.resource_group_name
  location = var.region_name
  key_vault_key_id = azurerm_key_vault_key.cmk_disk_encryption[0].id

  identity {
    type = "SystemAssigned"
  }

  tags = merge({"Name" = local.des_name}, local.module_common_tags)
}

resource azurerm_role_assignment cmk_disk_encryption {
  count = var.aks_disk_encryption_enabled ? 1 : 0
  principal_id = azurerm_disk_encryption_set.cmk_disk_encryption[0].identity[0].principal_id
  scope = azurerm_key_vault_key.cmk_disk_encryption[0].key_vault_id
  description = "Allow AKS control plane identity to read the disk encryption key from KeyVault"
  role_definition_name = "Key Vault Crypto Service Encryption User"
}
