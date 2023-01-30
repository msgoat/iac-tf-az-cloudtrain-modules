output public_dns_zone_ids {
  description = "Unique identifiers of all newly created public DNS zones"
  value = azurerm_dns_zone.public.*.id
}

output public_dns_zone_resource_group_name {
  description = "Name of the resource group owning all newly created public DNS zones"
  value = var.resource_group_name
}
