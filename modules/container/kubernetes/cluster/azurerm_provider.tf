# configuration of the AzureRM provider
provider azurerm {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
      purge_soft_deleted_keys_on_destroy = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_secrets_on_destroy = false
    }
  }
}