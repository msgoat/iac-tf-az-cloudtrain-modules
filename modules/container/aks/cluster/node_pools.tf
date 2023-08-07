locals {
  enabled_system_pool_templates = [for npt in var.node_pool_templates : npt if npt.enabled && npt.role == "system"]
  enabled_user_pool_templates = [for npt in var.node_pool_templates : npt if npt.enabled && npt.role == "user"]
  normalized_system_pool_templates = [for npt in local.enabled_system_pool_templates : {
    enabled = npt.enabled
    name = npt.name
    role = npt.role
    vm_sku = npt.vm_sku
    max_size = npt.max_size
    min_size = npt.min_size
    desired_size = npt.desired_size == 0 ? npt.min_size : npt.desired_size
    max_surge = npt.max_surge == "" ? "33%" : npt.max_surge
    kubernetes_version = (npt.kubernetes_version == null || npt.kubernetes_version == "") ? var.kubernetes_version : npt.kubernetes_version
    os_disk_size = npt.os_disk_size
    subnet_id = (npt.subnet_id == null || npt.subnet_id == "") ? var.system_pool_subnet_id : npt.subnet_id
    labels = npt.labels
    taints = npt.taints
  }]
  normalized_user_pool_templates = [for npt in local.enabled_user_pool_templates : {
    enabled = npt.enabled
    name = npt.name
    role = npt.role
    vm_sku = npt.vm_sku
    max_size = npt.max_size
    min_size = npt.min_size
    desired_size = npt.desired_size == 0 ? npt.min_size : npt.desired_size
    max_surge = npt.max_surge == "" ? "33%" : npt.max_surge
    kubernetes_version = (npt.kubernetes_version == null || npt.kubernetes_version == "") ? var.kubernetes_version : npt.kubernetes_version
    os_disk_size = npt.os_disk_size
    subnet_id = (npt.subnet_id == null || npt.subnet_id == "") ? var.user_pool_subnet_id : npt.subnet_id
    labels = npt.labels
    taints = npt.taints
  }]
}