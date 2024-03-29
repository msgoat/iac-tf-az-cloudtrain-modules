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

output "terraform_backend_file" {
  description = "Contents of the backend.tf file to be added to project"
  value       = local.terraform_backend_file
}

output "terragrunt_remote_state_block" {
  description = "Contents of remote_state block to be added to Terragrunt configuration files"
  value       = local.terragrunt_remote_state_block
}