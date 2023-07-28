locals {
  # /subscriptions/227d5934-f446-4e1b-b8d2-06f2942b64cb/resourceGroups/rg-euw-cxpk8sch-dev-miket92/providers/Microsoft.Network/virtualNetworks/vnet-euw-cxpk8sch-dev-miket92
  vnet_id_parts = split("/", var.vnet_id)
  vnet_rg_name     = local.vnet_id_parts[4]
  vnet_name     = local.vnet_id_parts[8]
}

data "azurerm_virtual_network" "given" {
  name = local.vnet_name
  resource_group_name = local.vnet_rg_name
}