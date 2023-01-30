resource azurerm_log_analytics_workspace shared {
  count = var.azure_monitor_enabled ? 1 : 0
  name = "law-${var.region_code}-${var.solution_fqn}"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  sku = var.log_analytics_workspace_sku
  retention_in_days = var.log_analytics_workspace_retention
  daily_quota_gb = var.log_analytics_workspace_daily_data_limit
  tags = merge({ Name = "law-${var.region_code}-${var.solution_fqn}" }, local.module_common_tags)
}