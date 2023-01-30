locals {
  postgres_server_name = "pg-${var.region_code}-${var.solution_fqn}-${var.db_instance_name}"
  # make sure that random user name does not start with a digit
  db_master_user_name = length(regexall("^[[:digit:]]", random_string.db_user.result)) > 0 ? "pg${random_string.db_user.result}" : random_string.db_user.result
}

# create an Azure PostgreSQL server instance using Single Server deployment mode
resource azurerm_postgresql_server postgres {
  name = local.postgres_server_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  sku_name = var.db_instance_sku
  version = var.postgresql_version
  administrator_login = local.db_master_user_name
  administrator_login_password = random_password.db_password.result
  auto_grow_enabled = var.db_autogrow_enabled
  backup_retention_days = var.db_backup_retention_days
  geo_redundant_backup_enabled = false
  infrastructure_encryption_enabled = false # not recommended; use storage encryption instead
  public_network_access_enabled = var.public_access_enabled
  ssl_enforcement_enabled = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = "TLS1_2"
  storage_mb = var.db_min_storage_size

  identity {
    type = "SystemAssigned"
  }

  tags = merge({ Name = local.postgres_server_name }, local.module_common_tags)
}