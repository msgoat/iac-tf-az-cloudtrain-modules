resource azurerm_dns_zone public {
  count = length(var.public_dns_zone_names)
  name = var.public_dns_zone_names[count.index]
  resource_group_name = var.resource_group_name
  tags = merge({ Name = "dnsz-${var.region_code}-${var.solution_fqn}-${count.index}" }, local.module_common_tags)
}