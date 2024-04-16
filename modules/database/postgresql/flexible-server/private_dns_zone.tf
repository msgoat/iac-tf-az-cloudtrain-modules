# retrieve private DNS zone supposed to host DNS records for private endpoints to Azure PostgreSQL,
# if private endpoints are enabled
data azurerm_private_dns_zone zone {
  count = var.private_endpoint_enabled ? 1 : 0
  name = "privatelink.postgres.database.azure.com"
  resource_group_name = var.private_endpoint_dns_zone_resource_group_name
}