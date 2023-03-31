locals {
  managed_identity_name = "id-${var.region_code}-${var.solution_fqn}-${var.virtual_machine_name}"
}

# create a user managed identity for the container group
resource "azurerm_user_assigned_identity" "this" {
  name                = local.managed_identity_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = var.region_name
  tags = merge({
    Name = local.managed_identity_name
  }, local.module_common_tags)
}
