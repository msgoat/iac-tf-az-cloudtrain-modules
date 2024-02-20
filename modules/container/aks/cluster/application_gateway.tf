locals {
  agw_id_parts        = var.aks_addon_agic_enabled ? split("/", var.aks_addon_agic_application_gateway_id) : []
  agw_subscription_id = length(local.agw_id_parts) != 0 ? local.agw_id_parts[2] : ""
  agw_rg_name         = length(local.agw_id_parts) != 0 ? local.agw_id_parts[4] : ""
  agw_name            = length(local.agw_id_parts) != 0 ? local.agw_id_parts[8] : ""
}

data "azurerm_application_gateway" "given" {
  count               = var.aks_addon_agic_enabled ? 1 : 0
  name                = local.agw_name
  resource_group_name = local.agw_rg_name
}
