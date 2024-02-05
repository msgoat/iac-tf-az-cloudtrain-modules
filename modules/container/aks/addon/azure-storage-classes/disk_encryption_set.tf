locals {
  des_name = "des-${local.aks_cluster_name}-pvc"
}

# create an instance of a disk encryption set
resource azurerm_disk_encryption_set cmk_pvc_encryption {
  name = local.des_name
  resource_group_name = data.azurerm_resource_group.given.name
  location = var.region_name
  key_vault_key_id = azurerm_key_vault_key.cmk_pvc_encryption.id

  identity {
    type = "SystemAssigned"
  }

  tags = merge({"Name" = local.des_name}, local.module_common_tags)
}

resource azurerm_role_assignment cmk_pvc_encryption {
  principal_id = azurerm_disk_encryption_set.cmk_pvc_encryption.identity[0].principal_id
  scope = azurerm_key_vault_key.cmk_pvc_encryption.key_vault_id
  description = "Allow Disc Encryption Set identity to read the disk encryption key from KeyVault"
  role_definition_name = "Key Vault Crypto Service Encryption User"
}
