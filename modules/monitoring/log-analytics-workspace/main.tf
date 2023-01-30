terraform {
  required_providers {
    azurerm = {
      version = "~> 3.0"
    }
  }
}

locals {
  module_common_tags = var.common_tags
}
