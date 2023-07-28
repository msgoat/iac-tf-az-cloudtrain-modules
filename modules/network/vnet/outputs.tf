output "vnet_id" {
  description = "Unique identifier of the newly created VNet."
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Fully qualified name of the newly created VNet."
  value       = azurerm_virtual_network.vnet.name
}

output "subnets" {
  description = "Information about all created subnets"
  value       = local.subnet_infos
}