locals {
  key_vault_name = "kv-${var.solution_fqn}"
}

resource azurerm_key_vault vault {
  name = local.key_vault_name
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  tenant_id = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  enable_rbac_authorization = true
  purge_protection_enabled = true
  public_network_access_enabled = true # required to be able to access KV from Terraform scripts executed locally
  soft_delete_retention_days = 7
  sku_name = "standard"

  lifecycle {
    ignore_changes = [ access_policy ]
  }

  tags = merge({
    "Name" = local.key_vault_name
  }, local.module_common_tags)
}
