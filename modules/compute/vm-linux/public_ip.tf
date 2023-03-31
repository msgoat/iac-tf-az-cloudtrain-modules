locals {
  public_ip_name = "pip-${var.region_code}-${var.solution_fqn}-${var.virtual_machine_name}"
}

resource "azurerm_public_ip" "this" {
  count               = var.public_access_enabled ? 1 : 0
  name                = local.public_ip_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = var.region_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge({
    "Name" = local.public_ip_name
  }, local.module_common_tags)
}
