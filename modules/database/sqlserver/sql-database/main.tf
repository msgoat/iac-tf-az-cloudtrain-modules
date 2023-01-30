terraform {
  required_providers {
    azurerm = {
      version = "~> 2.64"
    }
    random = {
      version = "~> 3.0"
    }
  }
}

locals {
  module_common_tags = var.common_tags
}
