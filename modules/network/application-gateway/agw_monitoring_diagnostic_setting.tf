resource azurerm_monitor_diagnostic_setting agw {
  count = var.agw_monitoring_enabled ? 1 : 0
  name = "mds-${local.agw_name}"
  target_resource_id = azurerm_application_gateway.gateway.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  log {
    category = "ApplicationGatewayAccessLog"
    retention_policy {
      enabled = true
      days = 14
    }
    enabled = true
  }

  log {
    category = "ApplicationGatewayPerformanceLog"
    retention_policy {
      enabled = true
      days = 7
    }
    enabled = true
  }

  log {
    category = "ApplicationGatewayFirewallLog"
    retention_policy {
      enabled = true
      days = 7
    }
    enabled = true
  }

  metric {
    category = "AllMetrics"
    enabled = true
    retention_policy {
      enabled = true
      days = 7
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type # Terraform always updates this resource if we don't ignore changes to this attribute
    ]
  }

}
