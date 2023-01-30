terraform {
  required_providers {
    azurerm = {
      version = "~> 2.64"
    }
  }
}

locals {
  module_common_tags = var.common_tags
}
