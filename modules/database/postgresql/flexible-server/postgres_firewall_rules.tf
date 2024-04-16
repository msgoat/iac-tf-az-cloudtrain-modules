# since the PostgreSQL firewall denies all public access by default, we explicitly have to add rules for given IP addresses
resource azurerm_postgresql_firewall_rule allow_public_access_from {
  count = length(var.allow_public_access_from_ips)
  name = "pgfwr-${azurerm_postgresql_server.postgres.name}-${replace(var.allow_public_access_from_ips[count.index], ".", "-")}"
  resource_group_name = var.resource_group_name
  server_name = azurerm_postgresql_server.postgres.name
  start_ip_address = var.allow_public_access_from_ips[count.index]
  end_ip_address = var.allow_public_access_from_ips[count.index]
}