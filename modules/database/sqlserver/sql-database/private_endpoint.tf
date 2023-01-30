locals {
  private_endpoint_name = "pep-${azurerm_mssql_server.server.name}"
}

# drop a private endpoint to the SQLServer server into the given subnet for private endpoints,
# if private endpoints are enabled
resource azurerm_private_endpoint server {
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
    name = azurerm_mssql_server.server.name
    private_connection_resource_id = azurerm_mssql_server.server.id
    subresource_names = [
      "sqlServer"]
  }
}
