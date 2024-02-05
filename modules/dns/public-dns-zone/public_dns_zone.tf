resource "azurerm_dns_zone" "public" {
  name                = var.dns_zone_name
  resource_group_name = data.azurerm_resource_group.given.name
  tags                = local.module_common_tags
}