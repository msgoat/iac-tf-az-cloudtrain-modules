terraform {
  required_providers {
    azurerm = {
      version = "~> 3.0"
    }
  }
}

locals {
  resource_group_name = lower("rg-${var.region_code}-${var.solution_name}-${var.solution_stage}-terraform")
  storage_account_name = replace(lower("st${var.region_code}${var.solution_name}${var.solution_stage}tf"), "-", "")
  storage_container_name = lower("stc-${var.region_code}-${var.solution_name}-${var.solution_stage}-backend")
}

resource azurerm_resource_group backend {
  name = local.resource_group_name
  location = var.region_name
  tags = merge({"Name" = local.resource_group_name}, var.common_tags)
}

resource azurerm_storage_account backend {
  name = local.storage_account_name
  resource_group_name = azurerm_resource_group.backend.name
  location = azurerm_resource_group.backend.location
  account_kind = "StorageV2"
  account_tier = "Standard"
  account_replication_type = "ZRS"
  enable_https_traffic_only = true
  min_tls_version = "TLS1_2"
  tags = merge({"Name" = local.storage_account_name}, var.common_tags)
}

resource azurerm_storage_container backend {
  name = local.storage_container_name
  storage_account_name = azurerm_storage_account.backend.name
}
