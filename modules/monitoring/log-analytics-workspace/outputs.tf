output log_analytics_workspace_id {
  description = "Unique identifier of the newly created log analytics workspace"
  value = azurerm_log_analytics_workspace.this.id
}

output log_analytics_workspace_name {
  description = "Name of the newly created log analytics workspace"
  value = azurerm_log_analytics_workspace.this.name
}

output log_analytics_workspace_resource_group_name {
  description = "Name of the resource group owning the newly created log analytics workspace"
  value = azurerm_log_analytics_workspace.this.resource_group_name
}
