output resource_group_name {
  description = "Name of the Azure resource group owing the Terraform backend resources"
  value = azurerm_resource_group.backend.name
}

output storage_account_name {
  description = "Name of the Azure storage account storing the Terraform state"
  value = azurerm_storage_account.backend.name
}

output storage_container_name {
  description = "Name of the Azure storage container used to store the Terraform state"
  value = azurerm_storage_container.backend.name
}