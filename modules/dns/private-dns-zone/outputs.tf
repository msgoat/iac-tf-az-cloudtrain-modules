output private_dns_zone_ids {
  description = "Unique identifiers of all newly creates private DNS zones"
  value = [for z in azurerm_private_dns_zone.zones : z.id]
}

output private_dns_zone_resource_group_name {
  description = "Name of the resource group owning all newly created private DNS zones"
  value = var.resource_group_name
}
