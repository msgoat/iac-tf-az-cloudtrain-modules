locals {
  key_vault_id_parts = split("/", var.key_vault_id)
  key_vault_name = local.key_vault_id_parts[8]
  key_vault_resource_group_name = local.key_vault_id_parts[4]
}

# retrieve Key Vault supposed to hold the SQLServer secret
data azurerm_key_vault shared {
  name = local.key_vault_name
  resource_group_name = local.key_vault_resource_group_name
}

