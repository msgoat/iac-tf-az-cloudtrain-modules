terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

locals {
  module_common_tags = merge(var.common_tags, { TerraformModuleName = "container/aks/addon/ingress-azure" })
  solution_fqn       = var.solution_fqn
}
