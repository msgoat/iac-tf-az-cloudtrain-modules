# Allow the current user to manage the newly created Key Vault
resource "azurerm_role_assignment" "creator" {
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = data.azurerm_resource_group.given.id
  role_definition_name = "Key Vault Administrator"
}

# Allow the members of given groups to manage the newly created Key Vault
resource "azurerm_role_assignment" "admins" {
  for_each             = toset(var.key_vault_admin_group_ids)
  principal_id         = each.value
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Administrator"
}
