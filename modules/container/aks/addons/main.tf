module "azure_storage_classes" {
  source            = "../addon/azure-storage-classes"
  count             = var.addon_azure_storage_classes_enabled ? 1 : 0
  region_name       = var.region_name
  region_code       = var.region_code
  solution_name     = var.solution_name
  solution_stage    = var.solution_stage
  solution_fqn      = var.solution_fqn
  common_tags       = var.common_tags
  resource_group_id = var.resource_group_id
  aks_cluster_id    = var.aks_cluster_id
}

module "cert_manager" {
  source                   = "../addon/cert-manager"
  count                    = var.addon_cert_manager_enabled ? 1 : 0
  region_name              = var.region_name
  region_code              = var.region_code
  solution_name            = var.solution_name
  solution_stage           = var.solution_stage
  solution_fqn             = var.solution_fqn
  common_tags              = var.common_tags
  aks_cluster_id           = var.aks_cluster_id
  resource_group_id        = var.resource_group_id
  dns_zone_id              = var.dns_zone_id
  letsencrypt_account_name = var.letsencrypt_account_name
}
