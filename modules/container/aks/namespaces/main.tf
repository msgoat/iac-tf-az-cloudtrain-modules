terraform {
  required_providers {
    azurerm = {
      version = "~> 3.0"
    }
    kubernetes = {
      version = "~> 2.1"
    }
  }
}

locals {
  module_common_tags = merge(var.common_tags, { TerraformModuleName = "container/aks/namespaces" })
}
