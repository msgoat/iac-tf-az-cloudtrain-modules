terraform {
  required_providers {
    azurerm = {
      version = "~> 3.41"
    }
    null = {
      version = "~> 3.0"
    }
    kubernetes = {
      version = "~> 2.17"
    }
  }
}

locals {
  module_common_tags = merge(var.common_tags, {TerraformModule = "aks/aksCluster"})
}
