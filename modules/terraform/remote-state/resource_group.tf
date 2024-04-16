locals {
  resource_group_name = lower("rg-${module.region.region_info.region_code}-${var.solution_fqn}-${var.backend_name}-tfstate")
}

resource azurerm_resource_group this {
  name = local.resource_group_name
  location = var.region_name
  tags = merge({Name = local.resource_group_name}, local.module_common_tags)
}
