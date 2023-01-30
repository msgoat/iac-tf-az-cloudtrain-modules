terraform {
  required_providers {
    azurerm = {
      version = "~> 2.70"
    }
    kubernetes = {
      version = "~> 2.4"
    }
  }
}

locals {
  module_common_tags = var.common_tags
}
