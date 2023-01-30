locals {
  cmk_key_name = "key-${local.sqlserver_server_name}"
}

# allow this postgres instance to access it's customer managed key used to encrypt data at rest
resource azurerm_key_vault_access_policy cmk_access {
  count = var.sqlserver_cmk_enabled ? 1 : 0
  key_vault_id = data.azurerm_key_vault.shared.id
  tenant_id = azurerm_mssql_server.server.identity[0].tenant_id
  object_id = azurerm_mssql_server.server.identity[0].principal_id
  key_permissions = [
    "get",
    "unwrapkey",
    "wrapkey"]
}

# create a customer managed key to encrypt data at rest for this postgres instance
resource azurerm_key_vault_key cmk {
  count = var.sqlserver_cmk_enabled ? 1 : 0
  name = local.cmk_key_name
  key_vault_id = data.azurerm_key_vault.shared.id
  key_type = "RSA"
  key_size = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"]
  tags = merge({
    Name = local.cmk_key_name
    RefersTo = azurerm_mssql_server.server.id
  }, local.module_common_tags)
  depends_on = [
    azurerm_key_vault_access_policy.cmk_access[0]]
}

# attach the customer managed key to this postgres instance
resource azurerm_mssql_server_transparent_data_encryption cmk {
  count = var.sqlserver_cmk_enabled ? 1 : 0
  server_id = azurerm_mssql_server.server.id
  key_vault_key_id = azurerm_key_vault_key.cmk[0].id
}


