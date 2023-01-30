module elasticsearch {
  source = "github.com/msgoat/iac-tf-az-database-modules/modules/database/elasticsearch/kubernetes"
  region_name = var.region_name
  region_code = var.region_code
  solution_name = var.solution_name
  solution_stage = var.solution_stage
  solution_fqn = var.solution_fqn
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  common_tags = local.module_common_tags
  aks_cluster_id = var.aks_cluster_id
  kubernetes_namespace_name = kubernetes_namespace.namespace.metadata[0].name
  elasticsearch_cluster_name = "es-logging"
  elasticsearch_node_storage_class = "cmk-csi-premium"
  key_vault_id = var.key_vault_id
  node_group_workload_class = var.node_group_workload_class
  topology_spread_strategy  = var.topology_spread_strategy
}