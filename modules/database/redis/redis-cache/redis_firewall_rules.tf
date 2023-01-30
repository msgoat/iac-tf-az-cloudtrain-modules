# since the Redis firewall denies all public access by default, we explicitly have to add rules for given IP addresses
resource azurerm_redis_firewall_rule allow_public_access_from {
  count = var.public_access_enabled ? length(var.allow_public_access_from_ips) : 0
  name = "rdfwr-${azurerm_redis_cache.redis.name}-${replace(var.allow_public_access_from_ips[count.index], ".", "-")}"
  resource_group_name = azurerm_redis_cache.redis.resource_group_name
  redis_cache_name = azurerm_redis_cache.redis.name
  start_ip = var.allow_public_access_from_ips[count.index]
  end_ip = var.allow_public_access_from_ips[count.index]
}