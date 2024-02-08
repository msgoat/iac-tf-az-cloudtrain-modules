locals {
  cmk_secret_encryption_key_name = "key-${local.aks_cluster_name}-secrets"
}

# create a cluster-specific customer managed key for secret encryption
resource "azurerm_key_vault_key" "cmk_secret_encryption" {
  name         = local.cmk_secret_encryption_key_name
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

  tags = merge({ "Name" = local.cmk_secret_encryption_key_name }, local.module_common_tags)
}

resource "azurerm_role_assignment" "allow_control_plane_to_access_secret_encryption_key" {
  principal_id         = azurerm_user_assigned_identity.control_plane.principal_id
  scope                = var.key_vault_id
  description          = "Allow AKS control plane identity to fully access the secret encryption key from KeyVault"
  role_definition_name = "Key Vault Crypto Officer"
}

resource "azurerm_role_assignment" "allow_kubelet_to_access_secret_encryption_key" {
  principal_id         = azurerm_user_assigned_identity.kubelet.principal_id
  scope                = var.key_vault_id
  description          = "Allow AKS kubelet identity to fully access the secret encryption key from KeyVault"
  role_definition_name = "Key Vault Crypto Officer"
}
