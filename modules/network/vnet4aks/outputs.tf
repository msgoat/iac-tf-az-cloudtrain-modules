output "vnet_id" {
  description = "Unique identifier of the newly created VNet."
  value = module.vnet.vnet_id
}

output "vnet_name" {
  description = "Fully qualified name of the newly created VNet."
  value = module.vnet.vnet_name
}

output "subnets" {
  description = "Information about all created subnets"
  value       = module.vnet.subnets
}

output "system_pool_subnet_id" {
  description = "Unique identifier of the subnet hosting all system pools"
  value       = [for sn in module.vnet.subnets : sn.subnet_id if sn.role == "SystemPoolContainer"][0]
}

output "user_pool_subnet_id" {
  description = "Unique identifier of the subnet hosting all user pools"
  value       = [for sn in module.vnet.subnets : sn.subnet_id if sn.role == "UserPoolContainer"][0]
}

output "private_endpoints_subnet_id" {
  description = "Unique identifier of the subnet hosting private endpoints"
  value       = [for sn in module.vnet.subnets : sn.subnet_id if sn.role == "PrivateEndpointContainer"][0]
}

output "web_subnet_id" {
  description = "Unique identifier of the subnet hosting all internet facing components like application gateways etc."
  value       = [for sn in module.vnet.subnets : sn.subnet_id if sn.role == "InternetFacingContainer"][0]
}

output "internal_loadbalancer_subnet_id" {
  description = "Unique identifier of the subnet hosting all internal loadbalancers"
  value       = [for sn in module.vnet.subnets : sn.subnet_id if sn.role == "InternalLoadBalancerContainer"][0]
}