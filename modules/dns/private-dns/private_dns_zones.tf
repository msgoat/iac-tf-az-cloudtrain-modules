resource azurerm_private_dns_zone zones {
  for_each = local.private_dns_zone_names
  name = each.value
  resource_group_name = var.resource_group_name
  tags = merge({ Name = "dnsz-${var.region_code}-${var.solution_fqn}-${replace(each.value, ".", "_")}" }, local.module_common_tags)
}