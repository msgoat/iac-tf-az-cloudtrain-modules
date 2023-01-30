output agw_id {
  description = "Unique identifier of the newly created application gateway"
  value = azurerm_application_gateway.gateway.id
}

output agw_name {
  description = "Name of the newly created application gateway"
  value = azurerm_application_gateway.gateway.name
}

output agw_resource_group_name {
  description = "Name of resource group owning the newly created application gateway"
  value = azurerm_application_gateway.gateway.resource_group_name
}

output agw_public_frontend_ip {
  description = "IP address of the application gateways public frontend"
  value = azurerm_public_ip.agw_external.ip_address
}
