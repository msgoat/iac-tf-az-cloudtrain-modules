locals {
  # /subscriptions/227d5934-f446-4e1b-b8d2-06f2942b64cb/resourceGroups/rg-weu-iactrain-dev-k8stst2024/providers/Microsoft.Network/virtualNetworks/vnet-weu-iactrain-dev-k8stst2024/subnets/snet-weu-iactrain-dev-k8stst2024-web
  subnet_id_parts        = split("/", var.subnet_id)
  subnet_subscription_id = local.subnet_id_parts[2]
  subnet_rg_name         = local.subnet_id_parts[4]
  vnet_name              = local.subnet_id_parts[8]
  subnet_name            = local.subnet_id_parts[10]
}

data "azurerm_virtual_network" "given" {
  name                = local.vnet_name
  resource_group_name = local.subnet_rg_name
}

data "azurerm_subnet" "given" {
  name                 = local.subnet_name
  resource_group_name  = local.subnet_rg_name
  virtual_network_name = local.vnet_name
}