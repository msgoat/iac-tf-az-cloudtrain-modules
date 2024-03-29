locals {
  managed_identity_name     = "id-${data.azurerm_kubernetes_cluster.given.name}-agic"
  federated_credential_name = "fidc-${data.azurerm_kubernetes_cluster.given.name}-agic"
}

# create a user managed identity
resource "azurerm_user_assigned_identity" "agic" {
  name                = local.managed_identity_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = data.azurerm_resource_group.given.location
  tags                = merge({ Name = local.managed_identity_name }, local.module_common_tags)
}

# allow managed identity to contribute to given DNS zone
resource "azurerm_role_assignment" "dns_zone_contributor" {
  principal_id         = azurerm_user_assigned_identity.agic.principal_id
  role_definition_name = "DNS Zone Contributor"
  scope                = var.dns_zone_id
}

# allow managed identity to read resource group owning given DNS zone
resource "azurerm_role_assignment" "resource_group_reader" {
  principal_id         = azurerm_user_assigned_identity.agic.principal_id
  role_definition_name = "Reader"
  scope                = data.azurerm_resource_group.public_dns_zone.id
}

# allow managed identity to contribute to given application gateway
resource "azurerm_role_assignment" "allow_contribute_to_given_application_gateway" {
  principal_id         = azurerm_user_assigned_identity.agic.principal_id
  role_definition_name = "Contributor"
  scope                = data.azurerm_application_gateway.given.id
}

# allow managed identity to operate managed identities of given application gateway
resource "azurerm_role_assignment" "allow_operate_identities_of_given_application_gateway" {
  principal_id         = azurerm_user_assigned_identity.agic.principal_id
  role_definition_name = "Managed Identity Operator"
  scope                = data.azurerm_application_gateway.given.identity[0].identity_ids[0]
}

# allow managed identity to join subnet of given application gateway
resource "azurerm_role_assignment" "allow_join_subnet_of_given_application_gateway" {
  principal_id         = azurerm_user_assigned_identity.agic.principal_id
  role_definition_name = "Network Contributor"
  scope                = data.azurerm_application_gateway.given.gateway_ip_configuration[0].subnet_id
}

# tell workload identity to trust the service account of the ingress controller
resource "azurerm_federated_identity_credential" "ingress_azure" {
  name                = local.federated_credential_name
  resource_group_name = data.azurerm_resource_group.given.name
  parent_id           = azurerm_user_assigned_identity.agic.id
  issuer              = data.azurerm_kubernetes_cluster.given.oidc_issuer_url
  subject             = "system:serviceaccount:${var.kubernetes_namespace_name}:${var.helm_release_name}"
  audience            = ["api://AzureADTokenExchange"]
}