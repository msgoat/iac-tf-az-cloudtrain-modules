locals {
  insights_name = "appi-${var.region_code}-${var.solution_fqn}"
}

resource azurerm_application_insights insights {
  name = local.insights_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  application_type = "java"
  daily_data_cap_in_gb = var.app_insights_daily_data_limit
  daily_data_cap_notifications_disabled = false
  retention_in_days = var.app_insights_retention
  workspace_id = var.log_analytics_workspace_id
  tags = merge({
    Name = local.insights_name
  }, local.module_common_tags)
}