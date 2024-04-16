# create an user-assigned identity to grant key vault access to application gateway
locals {
  agw_identity_name = "id-${local.agw_name}"
}

resource azurerm_user_assigned_identity agw {
  name = local.agw_identity_name
  resource_group_name = data.azurerm_resource_group.given.name
  location = data.azurerm_resource_group.given.location
  tags = merge({ Name = local.agw_identity_name }, local.module_common_tags)
}

resource azurerm_role_assignment agw_read_certificates {
  principal_id = azurerm_user_assigned_identity.agw.principal_id
  scope = length(var.agw_key_vault_certificate_name) != 0 ? data.azurerm_key_vault_certificate.given[0].key_vault_id : azurerm_key_vault_certificate.generated[0].key_vault_id
  description = "Allow Application Gateway to read the TLS certificate from KeyVault"
  role_definition_name = "Key Vault Certificates Officer"
}

resource azurerm_role_assignment agw_read_secrets {
  principal_id = azurerm_user_assigned_identity.agw.principal_id
  scope = var.key_vault_id
  description = "Allow Application Gateway to read secrets from KeyVault"
  role_definition_name = "Key Vault Secrets User"
}
