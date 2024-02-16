# create an user-assigned identity to grant key vault access to application gateway
locals {
  agw_identity_name = "id-${local.agw_name}"
}

resource "azurerm_user_assigned_identity" "gateway" {
  name                = local.agw_identity_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = data.azurerm_resource_group.given.location
  tags                = merge({ Name = local.agw_identity_name }, local.module_common_tags)
}

resource "azurerm_role_assignment" "allow_contribute_to_network" {
  principal_id         = azurerm_user_assigned_identity.gateway.principal_id
  scope                = data.azurerm_virtual_network.given.id
  description          = "Allow Application Gateway to contribute to given network"
  role_definition_name = "Network Contributor"
}

resource "azurerm_role_assignment" "allow_operate_identities" {
  principal_id         = azurerm_user_assigned_identity.gateway.principal_id
  scope                = data.azurerm_resource_group.given.id
  description          = "Allow Application Gateway to operate managed identities in given resource group"
  role_definition_name = "Managed Identity Operator"
}
