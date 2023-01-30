locals {
  public_dns_zone_id_parts = split("/", var.public_dns_zone_id)
  public_dns_zone_resource_group_name = local.public_dns_zone_id_parts[4]
  public_dns_zone_name = local.public_dns_zone_id_parts[8]
}

data azurerm_dns_zone public {
  name = local.public_dns_zone_name
  resource_group_name = local.public_dns_zone_resource_group_name
}