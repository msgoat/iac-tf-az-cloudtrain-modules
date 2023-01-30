terraform {
  required_providers {
    kubernetes = {
      version = "~> 2.1"
    }
  }
}

locals {
  module_common_tags = var.common_tags
}
