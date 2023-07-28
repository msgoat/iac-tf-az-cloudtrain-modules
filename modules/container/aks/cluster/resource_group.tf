locals {
  # /subscriptions/227d5934-f446-4e1b-b8d2-06f2942b64cb/resourceGroups/rg-eu-west-cloudtrain-core
  rg_id_parts = split("/", var.resource_group_id)
  rg_name     = local.rg_id_parts[4]
}

data "azurerm_resource_group" "given" {
  name = local.rg_name
}