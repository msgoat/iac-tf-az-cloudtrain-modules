locals {
  managed_identity_name = "id-${data.azurerm_kubernetes_cluster.given.name}-cert-manager"
  federated_credential_name = "fidc-${data.azurerm_kubernetes_cluster.given.name}-cert-manager"
}

# create a user managed identity for cert manager
resource azurerm_user_assigned_identity cert_manager {
  name = local.managed_identity_name
  resource_group_name = data.azurerm_resource_group.given.name
  location = data.azurerm_resource_group.given.location
  tags = merge({ Name = local.managed_identity_name }, local.module_common_tags)
}

# allow managed identity for cert manager to contribute to given DNS zone
resource azurerm_role_assignment dns_zone_contributor {
  principal_id = azurerm_user_assigned_identity.cert_manager.principal_id
  role_definition_name = "DNS Zone Contributor"
  scope = var.dns_zone_id
}

# tell workload identity to trust the service account of cert-manager
resource azurerm_federated_identity_credential cert_manager {
  name = local.federated_credential_name
  resource_group_name = data.azurerm_resource_group.given.name
  parent_id = azurerm_user_assigned_identity.cert_manager.id
  issuer = data.azurerm_kubernetes_cluster.given.oidc_issuer_url
  subject = "system:serviceaccount:${var.kubernetes_namespace_name}:${var.helm_release_name}"
  audience = [ "api://AzureADTokenExchange" ]
}