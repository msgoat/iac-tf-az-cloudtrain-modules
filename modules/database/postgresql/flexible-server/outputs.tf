output db_instance_id {
  description = "Unique identifier of the newly created Azure PostgreSQL server instance"
  value = azurerm_postgresql_server.postgres.id
}

output db_instance_name {
  description = "Name of the newly created Azure PostgreSQL server instance"
  value = azurerm_postgresql_server.postgres.name
}

output db_instance_resource_group_name {
  description = "Name of the resource group owning the newly created Azure PostgreSQL server instance"
  value = azurerm_postgresql_server.postgres.resource_group_name
}

output db_host_name {
  description = "Host name of the newly created Azure PostgreSQL server instance"
  value = azurerm_postgresql_server.postgres.fqdn
}

output db_port_number {
  description = "Port number of the newly created Azure PostgreSQL server instance"
  value = 5432
}

output db_database_name {
  description = "Name of the default database hosted by the newly created Azure PostgreSQL server instance"
  value = length(var.db_database_name) != 0 ? azurerm_postgresql_database.database[0].name : ""
}

output key_vault_secret_id {
  description = "Unique identifier of a Key Vault secret holding username and password of the PostgreSQL admin user"
  value = azurerm_key_vault_secret.postgres.id
}
