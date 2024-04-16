# add a DNS A record referring to the private endpoint address of the PostgreSQL server to the private DNS zone,
# if private endpoints are enabled
resource azurerm_private_dns_a_record postgres {
  count = var.private_endpoint_enabled ? 1 : 0
  name = azurerm_postgresql_server.postgres.name
  resource_group_name = data.azurerm_private_dns_zone.zone[0].resource_group_name
  zone_name = data.azurerm_private_dns_zone.zone[0].name
  records = [azurerm_private_endpoint.postgres[0].private_service_connection[0].private_ip_address]
  ttl = 3600
  tags = merge({
    Name = "dnsr-${azurerm_postgresql_server.postgres.name}"
  }, local.module_common_tags)
}