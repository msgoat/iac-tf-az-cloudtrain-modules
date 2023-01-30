locals {
  redis_server_name = "rd-${var.region_code}-${var.solution_fqn}-${var.db_instance_name}"
  redis_sku_parts = split("_", var.db_instance_sku)
  redis_sku_name = local.redis_sku_parts[0]
  redis_family = substr(local.redis_sku_parts[1], 0, 1)
  redis_capacity = tonumber(substr(local.redis_sku_parts[1], 1, 1))
}

# create an Azure Redis server instance
resource azurerm_redis_cache redis {
  name = local.redis_server_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  family = local.redis_family
  capacity = local.redis_capacity
  sku_name = local.redis_sku_name
  enable_non_ssl_port = var.ssl_enforcement_enabled ? false : true
  minimum_tls_version = "1.2"
  public_network_access_enabled = var.public_access_enabled

  tags = merge({ Name = local.redis_server_name }, local.module_common_tags)
}