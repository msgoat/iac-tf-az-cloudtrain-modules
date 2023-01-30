locals {
  pip_name = "pip-${local.agw_name}"
}

# create a public IP for the application gateway
resource azurerm_public_ip agw_external {
  name = local.pip_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = var.solution_fqn
  idle_timeout_in_minutes = 15
  tags = merge({Name = local.pip_name}, local.module_common_tags)

  lifecycle {
    create_before_destroy = true
  }
}
