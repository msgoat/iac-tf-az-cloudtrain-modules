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
  dns_zone_id              = var.public_dns_zone_id
  letsencrypt_account_name = var.letsencrypt_account_name
}

module "external_dns" {
  source            = "../addon/external-dns"
  count             = 0
  region_name       = var.region_name
  region_code       = var.region_code
  solution_name     = var.solution_name
  solution_stage    = var.solution_stage
  solution_fqn      = var.solution_fqn
  common_tags       = var.common_tags
  aks_cluster_id    = var.aks_cluster_id
  resource_group_id = var.resource_group_id
  dns_zone_id       = var.public_dns_zone_id
}

module "ingress_azure" {
  source                 = "../addon/ingress-azure"
  count                  = var.addon_ingress_azure_enabled ? 1 : 0
  region_name            = var.region_name
  region_code            = var.region_code
  solution_name          = var.solution_name
  solution_stage         = var.solution_stage
  solution_fqn           = var.solution_fqn
  common_tags            = var.common_tags
  aks_cluster_id         = var.aks_cluster_id
  resource_group_id      = var.resource_group_id
  dns_zone_id            = var.public_dns_zone_id
  application_gateway_id = var.loadbalancer_id
}

module "ingress_nginx" {
  source                          = "../addon/ingress-nginx"
  count                           = var.addon_ingress_nginx_enabled ? 1 : 0
  region_name                     = var.region_name
  region_code                     = var.region_code
  solution_name                   = var.solution_name
  solution_stage                  = var.solution_stage
  solution_fqn                    = var.solution_fqn
  common_tags                     = var.common_tags
  aks_cluster_id                  = var.aks_cluster_id
  resource_group_id               = var.resource_group_id
  public_dns_zone_id              = var.public_dns_zone_id
  host_names                      = var.host_names
  cert_manager_enabled            = var.addon_cert_manager_enabled
  cert_manager_issuer_name        = var.addon_cert_manager_enabled ? module.cert_manager[0].production_cluster_certificate_issuer_name : ""
  kubernetes_cluster_architecture = var.kubernetes_cluster_architecture
  loadbalancer_id                 = var.loadbalancer_id
  opentelemetry_enabled           = var.opentelemetry_enabled
  opentelemetry_collector_host    = var.opentelemetry_collector_host
  opentelemetry_collector_port    = var.opentelemetry_collector_port
}

locals {
  actual_ingress_class_name      = var.addon_ingress_nginx_enabled ? module.ingress_nginx[0].kubernetes_ingress_class_name : (var.addon_ingress_azure_enabled ? module.ingress_azure[0].kubernetes_ingress_class_name : "")
  actual_ingress_controller_type = var.addon_ingress_nginx_enabled ? module.ingress_nginx[0].kubernetes_ingress_controller_type : (var.addon_ingress_azure_enabled ? module.ingress_azure[0].kubernetes_ingress_controller_type : "")
}

module "eck_operator" {
  count                       = var.addon_eck_operator_enabled ? 1 : 0
  source                      = "../addon/eck-operator"
  region_name                 = var.region_name
  region_code                 = var.region_code
  solution_fqn                = var.solution_fqn
  solution_name               = var.solution_name
  solution_stage              = var.solution_stage
  common_tags                 = var.common_tags
  aks_cluster_id              = var.aks_cluster_id
  cert_manager_enabled        = var.addon_cert_manager_enabled
  prometheus_operator_enabled = false
}

