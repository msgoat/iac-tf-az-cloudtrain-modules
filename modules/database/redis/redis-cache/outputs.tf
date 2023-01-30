output db_instance_id {
  description = "Unique identifier of the newly created Azure Redis server instance"
  value = azurerm_redis_cache.redis.id
}

output db_instance_name {
  description = "Name of the newly created Azure Redis server instance"
  value = azurerm_redis_cache.redis.name
}

output db_instance_resource_group_name {
  description = "Name of the resource group owning the newly created Azure Redis server instance"
  value = azurerm_redis_cache.redis.resource_group_name
}

output db_host_name {
  description = "Host name of the newly created Azure Redis server instance"
  value = azurerm_redis_cache.redis.hostname
}

output db_port_number {
  description = "Port number of the newly created Azure Redis server instance"
  value = azurerm_redis_cache.redis.enable_non_ssl_port ? azurerm_redis_cache.redis.port : azurerm_redis_cache.redis.ssl_port
}

output kubernetes_secret_name {
  description = "Name of the Kubernetes secret added to all given namespaces, if kubernetes_secret_enabled was true"
  value = var.kubernetes_secret_enabled ? kubernetes_secret.redis.0.metadata.0.name : ""
}

output private_endpoint_ip {
  description = "Private IP address of the private endpoint, if private_endpoint_enabled was true"
  value = var.private_endpoint_enabled ? azurerm_private_endpoint.redis.0.private_service_connection.0.private_ip_address : ""
}
