locals {
  key_vault_secret_name = "${azurerm_postgresql_server.postgres.name}-${random_uuid.key_vault_secret_name_suffix.result}"
}

# create a Key Vault secret with username and password of PostgreSQL admin user
resource azurerm_key_vault_secret postgres {
  key_vault_id = data.azurerm_key_vault.shared.id
  name = local.key_vault_secret_name
  value = jsonencode({
    postgresql-user = "${random_string.db_user.result}@${azurerm_postgresql_server.postgres.name}"
    postgresql-password = random_password.db_password.result
  })
  content_type = "application/json"
  tags = merge({ Name = local.key_vault_secret_name, RefersTo = azurerm_postgresql_server.postgres.id }, local.module_common_tags)
}

# since we have purge protection enabled on Key Vault we have make secret names unique with a random suffix
resource random_uuid key_vault_secret_name_suffix {
}
