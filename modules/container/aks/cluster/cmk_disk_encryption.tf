locals {
  cmk_disk_encryption_key_name = "key-${local.aks_cluster_name}-disks"
  des_name                     = "des-${var.region_code}-${var.solution_fqn}-${var.kubernetes_cluster_name}-aks"
}

# create a cluster-specific customer managed key for disk encryption
resource "azurerm_key_vault_key" "cmk_disk_encryption" {
  name         = local.cmk_disk_encryption_key_name
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  tags = merge({ "Name" = local.cmk_disk_encryption_key_name }, local.module_common_tags)
}

# create an instance of a disk encryption set
resource "azurerm_disk_encryption_set" "cmk_disk_encryption" {
  name                = local.des_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = var.region_name
  key_vault_key_id    = azurerm_key_vault_key.cmk_disk_encryption.id

  identity {
    type = "SystemAssigned"
  }

  tags = merge({ "Name" = local.des_name }, local.module_common_tags)
}

resource "azurerm_role_assignment" "cmk_disk_encryption" {
  principal_id         = azurerm_disk_encryption_set.cmk_disk_encryption.identity[0].principal_id
  scope                = azurerm_key_vault_key.cmk_disk_encryption.key_vault_id
  description          = "Allow AKS control plane identity to read the disk encryption key from KeyVault"
  role_definition_name = "Key Vault Crypto Service Encryption User"
}
