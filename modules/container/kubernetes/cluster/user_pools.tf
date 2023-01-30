locals {
  user_pool_keys = [for np in var.node_pools : np.name if np.role == "user"]
  user_pool_values = [for np in var.node_pools : np if np.role == "user"]
  user_pools_by_name = zipmap(local.user_pool_keys, local.user_pool_values )
}

# create a user node group or user pool
resource azurerm_kubernetes_cluster_node_pool user_pool {
  for_each = local.user_pools_by_name
  name = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  mode = "User"
  vm_size = each.value.vm_sku
  zones = ["1", "2", "3"]
  enable_auto_scaling = true
  max_count = each.value.max_size
  min_count = each.value.min_size
  node_count = each.value.desired_size
  orchestrator_version = each.value.kubernetes_version
  os_disk_size_gb = each.value.os_disk_size
  os_type = "Linux"
  priority = "Regular"
  vnet_subnet_id = each.value.subnet_id
  node_labels = each.value.labels
  node_taints = each.value.taints
  tags = merge({ Name = "np-${var.region_code}-${var.solution_fqn}-${var.cluster_name}-${each.key}"}, local.module_common_tags)

  upgrade_settings {
    max_surge = each.value.max_surge
  }

  lifecycle {
    ignore_changes = [
      node_count, # node count may be changed by cluster autoscaler
      orchestrator_version # kubernetes version may be changed by azure cli or portal
    ]
  }
}
