output log_analytics_workspace_id {
  description = "Unique identifier of the newly created log analytics workspace"
  value = var.azure_monitor_enabled ? azurerm_log_analytics_workspace.shared[0].id : null
}

output log_analytics_workspace_name {
  description = "Name of the newly created log analytics workspace"
  value = var.azure_monitor_enabled ? azurerm_log_analytics_workspace.shared[0].name : null
}

output log_analytics_workspace_resource_group_name {
  description = "Name of the resource group owning the newly created log analytics workspace"
  value = var.azure_monitor_enabled ? azurerm_log_analytics_workspace.shared[0].resource_group_name : null
}
