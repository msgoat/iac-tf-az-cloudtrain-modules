terraform {
  required_providers {
    azurerm = {
      version = "~> 2.64"
    }
  }
}

locals {
  module_common_tags = var.common_tags
  private_dns_zone_names = toset(var.private_dns_zone_names)
}
