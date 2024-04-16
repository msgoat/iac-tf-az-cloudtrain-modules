locals {
  storage_account_name_default = replace(lower("st${var.solution_fqn}${var.backend_name}tf"), "-", "")
  storage_account_name_random = "st${random_string.this.result}"
  storage_account_name = length(local.storage_account_name_default) <= 24 ? local.storage_account_name_default : local.storage_account_name_random
  storage_container_name = "tfstate"
}

resource azurerm_storage_account this {
  name = local.storage_account_name
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  account_kind = "StorageV2"
  account_tier = "Standard"
  account_replication_type = "ZRS"
  enable_https_traffic_only = true
  min_tls_version = "TLS1_2"
  tags = merge({"Name" = local.storage_account_name}, local.module_common_tags)
}

resource azurerm_storage_container this {
  name = local.storage_container_name
  storage_account_name = azurerm_storage_account.this.name
}

resource random_string this {
  length = 22
  special = false
  upper = false
}
