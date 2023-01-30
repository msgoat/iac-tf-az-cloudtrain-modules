output "vnet_id" {
  description = "Unique identifier of the newly created VNet."
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Fully qualified name of the newly created VNet."
  value = azurerm_virtual_network.vnet.name
}

output "vnet_resource_group_name" {
  description = "Name of the resource group owning the VNet."
  value = azurerm_virtual_network.vnet.resource_group_name
}

output "application_gateway_subnet_id" {
  description = "Unique identifier of the application gateway subnet"
  value = azurerm_subnet.gateway.id
}

output "application_gateway_subnet_name" {
  description = "Name of the application gateway subnet"
  value = azurerm_subnet.gateway.name
}

output "application_gateway_subnet_cidr" {
  description = "CIDR address block of the application gateway subnet"
  value = azurerm_subnet.gateway.address_prefixes
}

output "loadbalancer_subnet_id" {
  description = "Unique identifier of the internal loadbalancer subnet"
  value = azurerm_subnet.loadbalancer.id
}

output "loadbalancer_subnet_name" {
  description = "Name of the internal loadbalancer subnet"
  value = azurerm_subnet.loadbalancer.name
}

output "loadbalancer_subnet_cidr" {
  description = "CIDR address block associated with the internal loadbalancer subnet"
  value = azurerm_subnet.loadbalancer.address_prefixes
}

output "system_pool_subnet_id" {
  description = "Unique identifier of the AKS system pool subnet"
  value = azurerm_subnet.system_pool.id
}

output "system_pool_subnet_name" {
  description = "Name of the AKS system pool subnet"
  value = azurerm_subnet.system_pool.name
}

output "system_pool_subnet_cidr" {
  description = "CIDR address block associated with the AKS system pool subnet"
  value = azurerm_subnet.system_pool.address_prefixes
}

output "user_pool_subnet_id" {
  description = "Unique identifier of the AKS user pool subnet"
  value = azurerm_subnet.user_pool.id
}

output "user_pool_subnet_name" {
  description = "Name of the AKS user pool subnet"
  value = azurerm_subnet.user_pool.name
}

output "user_pool_subnet_cidr" {
  description = "CIDR address block associated with the AKS user pool subnet"
  value = azurerm_subnet.user_pool.address_prefixes
}

output bastion_subnet_id {
  description = "Unique identifier of the bastion subnet"
  value = azurerm_subnet.bastion.id
}

output bastion_subnet_name {
  description = "Name of the bastion subnet"
  value = azurerm_subnet.bastion.name
}

output bastion_subnet_cidr {
  description = "CIDR adress block of the bastion subnet"
  value = azurerm_subnet.bastion.address_prefixes
}

output admin_subnet_id {
  description = "Unique identifier of the admin subnet"
  value = azurerm_subnet.admin.id
}

output admin_subnet_name {
  description = "Name of the admin subnet"
  value = azurerm_subnet.admin.name
}

output admin_subnet_cidr {
  description = "CIDR adress block of the admin subnet"
  value = azurerm_subnet.admin.address_prefixes
}

output private_endpoint_subnet_id {
  description = "Unique identifier of the subnet for private endpoints via private link"
  value = azurerm_subnet.endpoints.id
}

output private_endpoint_subnet_name {
  description = "Name of the subnet for private endpoints via private link"
  value = azurerm_subnet.endpoints.name
}

output private_endpoint_subnet_cidr {
  description = "CIDR block of the subnet for private endpoints via private link"
  value = azurerm_subnet.endpoints.address_prefixes
}

output subnets_by_role {
  description = "information about created subnets by role"
  value = local.subnets_by_role
}

output databases_subnet_id {
  description = "Unique identifier of the subnet for private databases"
  value = azurerm_subnet.databases.id
}

output databases_subnet_name {
  description = "Name of the subnet for private databases"
  value = azurerm_subnet.databases.name
}

output databases_subnet_cidr {
  description = "CIDR block of the subnet for private databases"
  value = azurerm_subnet.databases.address_prefixes
}
