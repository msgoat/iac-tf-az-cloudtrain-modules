locals {
  rg_id_parts = split("/", var.resource_group_id)
  rg_name     = local.rg_id_parts[4]
}

data "azurerm_resource_group" "given" {
  name = local.rg_name
}