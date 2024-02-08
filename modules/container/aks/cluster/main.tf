terraform {
  required_providers {
    azurerm = {
      version = "~> 3.0"
    }
    null = {
      version = "~> 3.0"
    }
  }
}

locals {
  module_common_tags = merge(var.common_tags, { TerraformModule = "container/aks/cluster" })
}
