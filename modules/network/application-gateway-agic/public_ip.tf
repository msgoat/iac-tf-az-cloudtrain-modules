locals {
  pip_name = "pip-${local.agw_name}"
}

# create a public IP for the application gateway
resource "azurerm_public_ip" "gateway" {
  name                    = local.pip_name
  resource_group_name     = data.azurerm_resource_group.given.name
  location                = data.azurerm_resource_group.given.location
  allocation_method       = "Static"
  sku                     = "Standard"
  domain_name_label       = var.solution_fqn
  idle_timeout_in_minutes = 15
  zones                   = var.names_of_zones_to_span
  tags                    = merge({ Name = local.pip_name }, local.module_common_tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ zones ]
  }
}
