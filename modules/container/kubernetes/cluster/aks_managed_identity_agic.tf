# assigns additional roles to managed identity for AGIC
# /subscriptions/227d5934-f446-4e1b-b8d2-06f2942b64cb/resourceGroups/rg-westeu-cxppltf-dev-cxp2022-nodes/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ingressapplicationgateway-aks-westeu-cxppltf-dev-cxp2022
locals {
  agic_identity_id_parts = var.aks_addon_agic_enabled ? split("/", azurerm_kubernetes_cluster.cluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].user_assigned_identity_id) : []
  agic_identity_resource_group_name = length(local.agic_identity_id_parts) > 0 ? local.agic_identity_id_parts[4] : null
  agic_identity_name = length(local.agic_identity_id_parts) > 0 ? local.agic_identity_id_parts[8] : null
}

# retrieve the managed identity for AGIC
data azurerm_user_assigned_identity agic {
  count = var.aks_addon_agic_enabled && var.aks_addon_agic_application_gateway_id != "" ? 1 : 0
  name = local.agic_identity_name
  resource_group_name = local.agic_identity_resource_group_name
}

# allow managed identity for AGIC to contribute to given Application Gateway
resource azurerm_role_assignment agw_contributor {
  count = var.aks_addon_agic_enabled && var.aks_addon_agic_application_gateway_id != "" ? 1 : 0
  principal_id = data.azurerm_user_assigned_identity.agic[0].principal_id
  role_definition_name = "Contributor"
  scope = var.aks_addon_agic_application_gateway_id
}
