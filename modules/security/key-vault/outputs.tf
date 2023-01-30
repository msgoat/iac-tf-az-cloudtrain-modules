output key_vault_id {
  description = "Unique identifier of the common key vault instance used by this solution."
  value = azurerm_key_vault.vault.id
}

output key_vault_name {
  description = "Name of the common key vault instance used by this solution."
  value = azurerm_key_vault.vault.name
}

output key_vault_resource_group_name {
  description = "Name of the resource group owning the key vault instance."
  value = azurerm_key_vault.vault.resource_group_name
}
