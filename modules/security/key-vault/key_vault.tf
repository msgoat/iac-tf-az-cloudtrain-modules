locals {
  kv_name_default = "kv-${module.region.region_info.region_code}-${var.solution_fqn}-${var.key_vault_name}"
  kv_name_random = "kv${random_string.this.result}"
  kv_name = length(local.kv_name_default) <= 24 ? local.kv_name_default : local.kv_name_random
}

resource "azurerm_key_vault" "this" {
  name                            = local.kv_name
  location                        = data.azurerm_resource_group.given.location
  resource_group_name             = data.azurerm_resource_group.given.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  purge_protection_enabled        = true
  public_network_access_enabled   = true # required to be able to access KV from Terraform scripts executed locally
  soft_delete_retention_days      = var.soft_delete_retention_days
  sku_name                        = var.key_vault_sku

  lifecycle {
    ignore_changes = [access_policy]
  }

  tags = merge({
    "Name" = local.kv_name
  }, local.module_common_tags)

  depends_on = [azurerm_role_assignment.creator]
}

resource random_string this {
  length = 22
  special = false
  upper = false
}