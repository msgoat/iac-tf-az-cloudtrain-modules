locals {
  vnet_name = "vnet-${var.region_code}-${var.solution_fqn}-${var.network_name}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = var.region_name
  address_space       = [var.network_cidr]
  tags                = merge({ "Name" = local.vnet_name }, local.module_common_tags)
}
