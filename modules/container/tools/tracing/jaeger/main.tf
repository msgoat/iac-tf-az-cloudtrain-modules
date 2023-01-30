terraform {
  required_providers {
    azurerm = {
      version = "~> 3.41"
    }
    helm = {
      version = "~> 2.8"
    }
    kubernetes = {
      version = "~> 2.17"
    }
    random = {
      version = "~> 3.4"
    }
  }
}

locals {
  module_common_tags = var.common_tags
}
