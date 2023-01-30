locals {
  key_vault_secret_name = "${azurerm_mssql_server.server.name}-${random_uuid.key_vault_secret_name_suffix.result}"
}

# create a Key Vault secret with username and password of SQLServer admin user
resource azurerm_key_vault_secret admin_user {
  key_vault_id = data.azurerm_key_vault.shared.id
  name = local.key_vault_secret_name
  value = jsonencode({
    sqlserver-user = random_string.admin_user.result
    sqlserver-password = random_password.admin_user.result
  })
  content_type = "application/json"
  tags = merge({
    Name = local.key_vault_secret_name,
    RefersTo = azurerm_mssql_server.server.id
  }, local.module_common_tags)
}

# since we have purge protection enabled on Key Vault we have make secret names unique with a random suffix
resource random_uuid key_vault_secret_name_suffix {
}
