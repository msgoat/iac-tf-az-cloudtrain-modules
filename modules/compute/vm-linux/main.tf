terraform {
  required_providers {
    azurerm = {
      version = "~> 3.50"
    }
    random = {
      version = "~> 3.0"
    }
    tls = {
      version = "~> 3.1"
    }
  }
}

locals {
  module_common_tags = merge(var.common_tags, { TerraformModuleName = "compute/vm-linux" })
}
