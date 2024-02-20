locals {
  # /subscriptions/227d5934-f446-4e1b-b8d2-06f2942b64cb/resourceGroups/rg-weu-iactrain-dev-k8stst2024/providers/Microsoft.Network/applicationGateways/agw-weu-iactrain-dev-k8stst2024
  agw_id_parts        = split("/", var.application_gateway_id)
  agw_subscription_id = local.agw_id_parts[2]
  agw_rg_name         = local.agw_id_parts[4]
  agw_name            = local.agw_id_parts[8]
}

data "azurerm_application_gateway" "given" {
  name                = local.agw_name
  resource_group_name = local.agw_rg_name
}
