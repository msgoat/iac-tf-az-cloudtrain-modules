terraform {
  required_providers {
    azurerm = {
      version = "~> 3.0"
    }
    random = {
      version = "~> 3.0"
    }
  }
}

locals {
  module_common_tags = merge(var.common_tags, { TerraformModuleName = "terraform/remote-state"})
}

locals {
  terraform_backend_file = <<EOT
terraform {
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.this.name}"
    storage_account_name = "${azurerm_storage_account.this.name}"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
EOT
  terraform_backend_config = <<EOT
resource_group_name  = "${azurerm_resource_group.this.name}"
storage_account_name = "${azurerm_storage_account.this.name}"
container_name       = "tfstate"
EOT
  terragrunt_remote_state_block = <<EOT
remote_state {
  backend = "azurerm"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    resource_group_name  = "${azurerm_resource_group.this.name}"
    storage_account_name = "${azurerm_storage_account.this.name}"
    container_name       = "tfstate"
    key                  = "$${path_relative_to_include()}/terraform.tfstate"
  }
}
EOT
}