locals {
  diagnostic_setting_name = "ds-${var.region_code}-${var.solution_fqn}-${var.cluster_name}-aks"
}

resource azurerm_monitor_diagnostic_setting cluster {
  count =  0 # var.azure_monitor_enabled ? 1 : 0
  name = local.diagnostic_setting_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  target_resource_id = azurerm_kubernetes_cluster.cluster.id

  dynamic log {
    for_each = var.diagnostic_settings.logs
    content {
      category = log.value
      enabled = true
      retention_policy {
        enabled = true
        days = var.diagnostic_settings.retention_days
      }
    }
  }

  dynamic metric {
    for_each = var.diagnostic_settings.metrics
    content {
      category = metric.value
      enabled = true
      retention_policy {
        enabled = true
        days = var.diagnostic_settings.retention_days
      }
    }
  }
}