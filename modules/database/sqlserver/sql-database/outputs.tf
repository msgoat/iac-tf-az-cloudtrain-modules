output db_instance_id {
  description = "Unique identifier of the newly created Azure SQLServer server instance"
  value = azurerm_mssql_server.server.id
}

output db_instance_name {
  description = "Name of the newly created Azure SQLServer server instance"
  value = azurerm_mssql_server.server.name
}

output db_instance_resource_group_name {
  description = "Name of the resource group owning the newly created Azure SQLServer server instance"
  value = azurerm_mssql_server.server.resource_group_name
}

output db_host_name {
  description = "Host name of the newly created Azure SQLServer server instance"
  value = azurerm_mssql_server.server.fully_qualified_domain_name
}

output db_port_number {
  description = "Port number of the newly created Azure SQLServer server instance"
  value = 1433
}

output db_database_name {
  description = "Name of the default database hosted by the newly created Azure SQLServer server instance"
  value = azurerm_mssql_database.database.name
}

output key_vault_secret_id {
  description = "Unique identifier of a Key Vault secret holding username and password of the SQLServer admin user"
  value = azurerm_key_vault_secret.admin_user.id
}

output key_vault_secret_name {
  description = "Name of a Key Vault secret holding username and password of the SQLServer admin user"
  value = azurerm_key_vault_secret.admin_user.name
}

output private_endpoint_ip {
  description = "Private IP address of the private endpoint, if private_endpoint_enabled was true"
  value = var.private_endpoint_enabled ? azurerm_private_endpoint.server.0.private_service_connection.0.private_ip_address : ""
}
