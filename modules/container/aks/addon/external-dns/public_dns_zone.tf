locals {
  # /subscriptions/227d5934-f446-4e1b-b8d2-06f2942b64cb/resourceGroups/rg-eu-west-cloudtrain-core/providers/Microsoft.Network/dnszones/k8s.azure.msgoat.eu
  public_dns_zone_id_parts = split("/", var.dns_zone_id)
  public_dns_zone_subscription_id  = local.public_dns_zone_id_parts[2]
  public_dns_zone_rg_name  = local.public_dns_zone_id_parts[4]
  public_dns_zone_name     = local.public_dns_zone_id_parts[8]
}

data azurerm_resource_group "public_dns_zone" {
  name = local.public_dns_zone_rg_name
}

data "azurerm_dns_zone" "given" {
  name                = local.public_dns_zone_name
  resource_group_name = local.public_dns_zone_rg_name
}
