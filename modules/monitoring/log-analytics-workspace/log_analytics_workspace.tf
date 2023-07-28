locals {
  law_name = "law-${var.region_code}-${var.solution_fqn}-${var.workspace_name}"
}
resource azurerm_log_analytics_workspace shared {
  name = local.law_name
  resource_group_name = data.azurerm_resource_group.given.name
  location = var.region_name
  sku = var.log_analytics_workspace_sku
  retention_in_days = var.log_analytics_workspace_retention
  daily_quota_gb = var.log_analytics_workspace_daily_data_limit
  tags = merge({ Name = local.law_name }, local.module_common_tags)
}