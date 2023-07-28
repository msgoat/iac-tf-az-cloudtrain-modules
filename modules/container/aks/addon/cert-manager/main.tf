terraform {
  required_providers {
    azurerm = {
      version = "~> 3.40"
    }
    helm = {
      version = "~> 2.8"
    }
    kubernetes = {
      version = "~> 2.16"
    }
  }
}

locals {
  module_common_tags = var.common_tags
  solution_fqn = var.solution_fqn
}
