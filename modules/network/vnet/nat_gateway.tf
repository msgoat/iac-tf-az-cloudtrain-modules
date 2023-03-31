locals {
  ngw_name  = "nat-${var.region_code}-${var.solution_fqn}-${var.network_name}"
  pip_name  = "pip-${var.region_code}-${var.solution_fqn}-${var.network_name}-nat"
  ngw_count = var.nat_strategy == "NAT_NONE" ? 0 : 1
}

resource "azurerm_nat_gateway" "this" {
  count               = local.ngw_count
  name                = local.ngw_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = var.region_name
  sku_name            = "Standard"
  tags = merge({
    Name = local.ngw_name
  }, local.module_common_tags)
}

resource "azurerm_public_ip" "this" {
  count               = local.ngw_count
  name                = local.pip_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = var.region_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  sku_tier            = "Regional"
  tags = merge({
    Name = local.ngw_name
  }, local.module_common_tags)
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count                = local.ngw_count
  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.this[0].id
}