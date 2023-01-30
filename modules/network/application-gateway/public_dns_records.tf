locals {
  # filter all host names not starting with '*'
  non_wildcard_host_names = [for current in var.agw_host_names : current if trimprefix(current, "*.") == current]
  domain_name_suffix = ".${local.public_dns_zone_name}"
  # filter all host names with matching domain name
  matching_host_names = [for current in local.non_wildcard_host_names : current if trimsuffix(current, local.domain_name_suffix) != current ]
  # trim domain name from all matching host names
  public_dns_record_names = [for current in local.matching_host_names : trimsuffix(current, local.domain_name_suffix) ]
  # filter all host names referring to the zone apex (i.e. host name equals domain name)
  zone_apex_record_names = [for current in var.agw_host_names : current if current == local.public_dns_zone_name]
}

# create a public DNS A alias record for a host name representing the zone apex (i.e. host name equals domain name)
resource azurerm_dns_a_record zone_apex {
  count = length(local.zone_apex_record_names)
  name = "@" # local.zone_apex_record_names[count.index]
  resource_group_name = data.azurerm_dns_zone.public.resource_group_name
  zone_name = data.azurerm_dns_zone.public.name
  ttl = 3600
  target_resource_id = azurerm_public_ip.agw_external.id
  tags = merge({"Name" = "dnsr-${var.region_code}-${var.solution_fqn}-${count.index}"}, local.module_common_tags)
}

# create a public DNS A record for each matching given host name pointing to the application gateway
resource azurerm_dns_a_record primary {
  count = length(local.public_dns_record_names)
  name = local.public_dns_record_names[count.index]
  resource_group_name = data.azurerm_dns_zone.public.resource_group_name
  zone_name = data.azurerm_dns_zone.public.name
  ttl = 300
  target_resource_id = azurerm_public_ip.agw_external.id
  tags = merge({"Name" = "dnsr-${var.region_code}-${var.solution_fqn}-${count.index}"}, local.module_common_tags)
}
