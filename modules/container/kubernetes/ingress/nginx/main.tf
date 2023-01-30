terraform {
  required_providers {
    helm = {
      version = "~> 2.1"
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
