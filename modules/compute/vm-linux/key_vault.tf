locals {
  # "/subscriptions/5945938d-2ee8-4229-ac6a-b0d1ff422981/resourceGroups/rg-westeu-echspltf-dev-stage/providers/Microsoft.KeyVault/vaults/kv-echspltf-dev"
  key_vault_id_parts            = split("/", var.key_vault_id)
  key_vault_name                = local.key_vault_id_parts[8]
  key_vault_resource_group_name = local.key_vault_id_parts[4]
}

# retrieve Key Vault supposed to hold the PostgreSQL secret
data "azurerm_key_vault" "shared" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_resource_group_name
}

