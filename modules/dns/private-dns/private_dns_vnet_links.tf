# link newly created private DNS zones to all given VNets
resource azurerm_private_dns_zone_virtual_network_link links {
  for_each = local.private_dns_zone_names
  name = "vnl-${var.region_code}-${var.solution_fqn}-${replace(each.value, ".", "_")}"
  resource_group_name = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.value].name
  virtual_network_id = var.vnet_id
  registration_enabled = false
  tags = merge({"Name" = "vnl-${var.region_code}-${var.solution_fqn}-${replace(each.value, ".", "_")}"}, local.module_common_tags)
}