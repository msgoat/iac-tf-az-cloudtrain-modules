locals {
  cmk_key_name = "key-${var.region_code}-${var.solution_fqn}-postgres-${var.db_instance_name}"
}

# allow this postgres instance to access it's customer managed key used to encrypt data at rest
resource azurerm_key_vault_access_policy cmk_access {
  count = var.postgres_encryption_enabled ? 1 : 0
  key_vault_id = data.azurerm_key_vault.shared.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_postgresql_server.postgres.identity.0.principal_id

  key_permissions    = ["get", "unwrapkey", "wrapkey"]
}

# create a customer managed key to encrypt data at rest for this postgres instance
resource azurerm_key_vault_key cmk {
  count = var.postgres_encryption_enabled ? 1 : 0
  name = local.cmk_key_name
  key_vault_id = data.azurerm_key_vault.shared.id
  key_type = "RSA"
  key_size = 2048
  key_opts = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  tags = merge({ Name = local.cmk_key_name }, local.module_common_tags)
  depends_on = [ azurerm_key_vault_access_policy.cmk_access[0] ]
}

# attach the customer managed key to this postgres instance
resource azurerm_postgresql_server_key cmk {
  count = var.postgres_encryption_enabled ? 1 : 0
  server_id = azurerm_postgresql_server.postgres.id
  key_vault_key_id = azurerm_key_vault_key.cmk[0].id
}


