module azure_storage_classes {
  source = "../addon/azure-storage-classes"
  region_name = var.region_name
  region_code = var.region_code
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  solution_name = var.solution_name
  solution_stage = var.solution_stage
  solution_fqn = var.solution_fqn
  common_tags = var.common_tags
  aks_cluster_id = var.aks_cluster_id
  aks_disk_encryption_set_id = var.aks_disk_encryption_set_id
  addon_enabled = var.addon_azure_storage_classes_enabled
}

module cert_manager {
  source = "../addon/cert-manager"
  region_name = var.region_name
  region_code = var.region_code
  solution_name = var.solution_name
  solution_stage = var.solution_stage
  solution_fqn = var.solution_fqn
  common_tags = var.common_tags
  aks_cluster_id = var.aks_cluster_id
  addon_enabled = var.addon_cert_manager_enabled
  node_group_workload_class = var.node_group_workload_class
}
