locals {
  vnet_name = "vnet-${var.region_code}-${var.solution_fqn}-${var.network_name}"
}

resource azurerm_virtual_network vnet {
  name = local.vnet_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  address_space = [var.network_cidr]
  tags = merge({"Name" = local.vnet_name}, local.module_common_tags)
}
