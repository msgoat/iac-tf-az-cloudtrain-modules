locals {
  # "/subscriptions/5945938d-2ee8-4229-ac6a-b0d1ff422981/resourceGroups/rg-westeu-echscicd-all-global/providers/Microsoft.Network/virtualNetworks/vnet-westeu-echscicd-all-pipeline/subnets/snet-westeu-echscicd-all-pipeline-public"
  subnet_id_parts          = split("/", var.subnet_id)
  vnet_resource_group_name = local.subnet_id_parts[4]
  vnet_name                = local.subnet_id_parts[8]
  subnet_name              = local.subnet_id_parts[10]
}

data "azurerm_virtual_network" "given" {
  name                = local.vnet_name
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "given" {
  name                 = local.subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_resource_group_name
}