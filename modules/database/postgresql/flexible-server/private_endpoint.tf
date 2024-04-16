locals {
  private_endpoint_name = "pep-${azurerm_postgresql_server.postgres.name}"
}

# drop a private endpoint to the PostgreSQL server into the given subnet for private endpoints,
# if private endpoints are enabled
resource azurerm_private_endpoint postgres {
  count = var.private_endpoint_enabled ? 1 : 0
  name = local.private_endpoint_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  subnet_id = var.private_endpoint_subnet_id
  tags = merge({
    Name = local.private_endpoint_name
  }, local.module_common_tags)

  private_service_connection {
    is_manual_connection = false
    name = azurerm_postgresql_server.postgres.name
    private_connection_resource_id = azurerm_postgresql_server.postgres.id
    subresource_names = [ "postgresqlServer" ]
  }
}
