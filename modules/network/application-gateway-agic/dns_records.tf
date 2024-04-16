locals {
  stripped_record_names = [for hn in var.host_names : split(".", hn)[0]]
  simple_zone_name      = split(".", data.azurerm_dns_zone.given.name)[0]
  canonic_record_names  = [for rn in local.stripped_record_names : (rn != local.simple_zone_name ? rn : "@")]
}

resource "azurerm_dns_a_record" "this" {
  for_each            = toset(local.canonic_record_names)
  name                = each.value
  resource_group_name = data.azurerm_resource_group.given.name
  zone_name           = data.azurerm_dns_zone.given.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.gateway.id
}