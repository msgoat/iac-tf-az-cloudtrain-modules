output "key_vault_id" {
  description = "Unique identifier of the common key vault instance used by this solution."
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Fully qualified name of the common key vault instance used by this solution."
  value       = azurerm_key_vault.this.name
}
