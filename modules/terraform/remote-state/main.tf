terraform {
  required_providers {
    azurerm = {
      version = "~> 3.0"
    }
  }
}

locals {
  module_common_tags = merge(var.common_tags, { TerraformModuleName = "terraform/remote-state"})
  resource_group_name = lower("rg-${var.region_code}-${var.solution_fqn}-${var.backend_name}-tfstate")
  storage_account_name = replace(lower("st${var.solution_fqn}${var.backend_name}tf"), "-", "")
  storage_container_name = "tfstate"
}

resource azurerm_resource_group backend {
  name = local.resource_group_name
  location = var.region_name
  tags = merge({"Name" = local.resource_group_name}, local.module_common_tags)
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
  tags = merge({"Name" = local.storage_account_name}, local.module_common_tags)
}

resource azurerm_storage_container backend {
  name = local.storage_container_name
  storage_account_name = azurerm_storage_account.backend.name
}

locals {
  terraform_backend_file = <<EOT
terraform {
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.backend.name}"
    storage_account_name = "${azurerm_storage_account.backend.name}"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
EOT
  terragrunt_remote_state_block = <<EOT
remote_state {
  backend = "azurerm"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    resource_group_name  = "${azurerm_resource_group.backend.name}"
    storage_account_name = "${azurerm_storage_account.backend.name}"
    container_name       = "tfstate"
    key                  = "$${path_relative_to_include()}/terraform.tfstate"
  }
}
EOT
}