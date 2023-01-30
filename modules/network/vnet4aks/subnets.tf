locals {
  subnet_name_prefix = "snet-${var.region_code}-${var.solution_fqn}-${var.network_name}"
  subnet_cidrs = cidrsubnets(var.network_cidr, 4, 4, 4, 4, 8, 8, 8, 8)
  system_pool_subnet_cidr = local.subnet_cidrs[0]
  user_pool_subnet_cidr = local.subnet_cidrs[1]
  database_subnet_cidr = local.subnet_cidrs[2]
  private_link_subnet_cidr = local.subnet_cidrs[3]
  application_gateway_subnet_cidr = local.subnet_cidrs[4]
  loadbalancer_subnet_cidr = local.subnet_cidrs[5]
  bastion_subnet_cidr = local.subnet_cidrs[6]
  admin_subnet_cidr = local.subnet_cidrs[7]
}

# create a subnet for application gateway
resource azurerm_subnet gateway {
  name = "${local.subnet_name_prefix}-gateway"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.application_gateway_subnet_cidr]
}

# create a subnet for the internal loadbalancer managed by AKS
resource azurerm_subnet loadbalancer {
  name = "${local.subnet_name_prefix}-loadbalancer"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.loadbalancer_subnet_cidr]
}

# create a subnet for the AKS system pool (master nodes)
resource azurerm_subnet system_pool {
  name = "${local.subnet_name_prefix}-system-pool"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.system_pool_subnet_cidr]
}

# create a subnet for the AKS user pool (worker nodes)
resource azurerm_subnet user_pool {
  name = "${local.subnet_name_prefix}-user-pool"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.user_pool_subnet_cidr]
}

# create a subnet for Azure Bastion service (troubleshooting etc)
resource azurerm_subnet bastion {
  name = "AzureBastion"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.bastion_subnet_cidr]
}

# create a subnet for internal administration of this virtual network (troubleshooting etc)
resource azurerm_subnet admin {
  name = "${local.subnet_name_prefix}-admin"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.admin_subnet_cidr]
}

# create a subnet for private endpoints to Azure services via Private Link
resource azurerm_subnet endpoints {
  name = "${local.subnet_name_prefix}-endpoints"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.private_link_subnet_cidr]
  private_endpoint_network_policies_enabled = false
}

# create a subnet for managed databases
resource azurerm_subnet databases {
  name = "${local.subnet_name_prefix}-databases"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.database_subnet_cidr]
}

locals {
  subnets_by_role = [
    {
      role = "SystemPoolContainer"
      id = azurerm_subnet.system_pool.id
      name = azurerm_subnet.system_pool.name
      address_prefixes = azurerm_subnet.system_pool.address_prefixes
    },
    {
      role = "UserPoolContainer"
      id = azurerm_subnet.user_pool.id
      name = azurerm_subnet.user_pool.name
      address_prefixes = azurerm_subnet.system_pool.address_prefixes
    },
    {
      role = "ApplicationGatewayContainer"
      id = azurerm_subnet.gateway.id
      name = azurerm_subnet.gateway.name
      address_prefixes = azurerm_subnet.gateway.address_prefixes
    },
    {
      role = "LoadBalancerContainer"
      id = azurerm_subnet.loadbalancer.id
      name = azurerm_subnet.loadbalancer.name
      address_prefixes = azurerm_subnet.loadbalancer.address_prefixes
    },
    {
      role = "BastionServiceContainer"
      id = azurerm_subnet.bastion.id
      name = azurerm_subnet.bastion.name
      address_prefixes = azurerm_subnet.bastion.address_prefixes
    },
    {
      role = "AdminMachinesContainer"
      id = azurerm_subnet.admin.id
      name = azurerm_subnet.admin.name
      address_prefixes = azurerm_subnet.admin.address_prefixes
    },
    {
      role = "PrivateEndpointsContainer"
      id = azurerm_subnet.endpoints.id
      name = azurerm_subnet.endpoints.name
      address_prefixes = azurerm_subnet.endpoints.address_prefixes
    },
    {
      role = "DatabaseContainer"
      id = azurerm_subnet.databases.id
      name = azurerm_subnet.databases.name
      address_prefixes = azurerm_subnet.databases.address_prefixes
    },
  ]
}
