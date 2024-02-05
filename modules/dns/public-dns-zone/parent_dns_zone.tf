locals {
  # /subscriptions/227d5934-f446-4e1b-b8d2-06f2942b64cb/resourceGroups/rg-eu-west-cloudtrain-core/providers/Microsoft.Network/dnszones/k8s.azure.msgoat.eu
  parent_dns_zone_id_parts = var.parent_dns_zone_id != "" ? split("/", var.parent_dns_zone_id) : []
  parent_dns_zone_rg_name  = length(local.parent_dns_zone_id_parts) > 4 ? local.parent_dns_zone_id_parts[4] : ""
  parent_dns_zone_name     = length(local.parent_dns_zone_id_parts) > 8 ? local.parent_dns_zone_id_parts[8] : ""
  child_dns_record_name    = split(".", var.dns_zone_name)[0]
}

data "azurerm_dns_zone" "parent" {
  count               = var.parent_dns_zone_id != "" ? 1 : 0
  name                = local.parent_dns_zone_name
  resource_group_name = local.parent_dns_zone_rg_name
}

resource "azurerm_dns_ns_record" "child" {
  count               = var.parent_dns_zone_id != "" ? 1 : 0
  name                = local.child_dns_record_name
  zone_name           = data.azurerm_dns_zone.parent[0].name
  resource_group_name = data.azurerm_dns_zone.parent[0].resource_group_name
  records             = azurerm_dns_zone.public.name_servers
  ttl                 = 300
}

