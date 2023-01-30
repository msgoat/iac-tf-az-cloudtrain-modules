terraform {
  required_providers {
    azurerm = {
      version = "~> 3.0"
    }
    null = {
      version = "~> 3.0"
    }
    kubernetes = {
      version = "~> 2.1"
    }
    time = {
      version = "~> 0.7"
    }
  }
}

locals {
  module_common_tags = var.common_tags
}
