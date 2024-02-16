resource "azurerm_monitor_diagnostic_setting" "gateway" {
  count                          = var.monitoring_enabled ? 1 : 0
  name                           = "mds-${local.agw_name}"
  target_resource_id             = azurerm_application_gateway.gateway.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type # Terraform always updates this resource if we don't ignore changes to this attribute
    ]
  }

}
