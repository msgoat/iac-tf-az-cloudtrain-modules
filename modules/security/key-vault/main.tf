terraform {
  required_providers {
    azurerm = {
      version = "~> 3.0"
    }
  }
}

locals {
  module_common_tags = merge(var.common_tags, { TerraformModuleName = "security/key-vault" })
}

data "azurerm_client_config" "current" {
}
