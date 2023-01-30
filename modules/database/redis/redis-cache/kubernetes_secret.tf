# create a Kubernetes secret with the username and the password of the Redis admin user in each given namespace
resource kubernetes_secret redis {
  count = var.kubernetes_secret_enabled ? length(var.kubernetes_namespace_names) : 0
  type = "Opaque"
  metadata {
    name = azurerm_redis_cache.redis.name
    namespace = var.kubernetes_namespace_names[count.index]
    labels = {
      "app.kubernetes.io/name" = azurerm_redis_cache.redis.name
      "app.kubernetes.io/component" = "secret"
      "app.kubernetes.io/part-of" = var.solution_name
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  # we are explicitly using binary_data with base64encode() to prevent sensitive data from showing up in terraform state
  binary_data = {
    redis-primary-access-key = base64encode(azurerm_redis_cache.redis.primary_access_key)
    redis-secondary-access-key = base64encode(azurerm_redis_cache.redis.secondary_access_key)
    redis-primary-connection-string = base64encode(azurerm_redis_cache.redis.primary_connection_string)
    redis-secondary-connection-string = base64encode(azurerm_redis_cache.redis.secondary_connection_string)
  }
}