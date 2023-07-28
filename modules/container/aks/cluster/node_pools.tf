locals {
  enabled_node_pools = [for np in var.node_pool_templates : np if np.enabled]
  normalized_node_pools = [for np in local.enabled_node_pools : {
    enabled = np.enabled
    name = np.name
    role = np.role
    vm_sku = np.vm_sku
    max_size = np.max_size
    min_size = np.min_size
    desired_size = np.desired_size == 0 ? np.min_size : np.desired_size
    max_surge = np.max_surge == "" ? "33%" : np.max_surge
    kubernetes_version = (np.kubernetes_version == null || np.kubernetes_version == "") ? var.kubernetes_version : np.kubernetes_version
    os_disk_size = np.os_disk_size
    subnet_id = np.subnet_id
    labels = np.labels
    taints = np.taints
  }]
  system_pools = [for np in local.normalized_node_pools : np if np.role == "system"]
  user_pools =  [for np in local.normalized_node_pools : np if np.role == "user"]
}