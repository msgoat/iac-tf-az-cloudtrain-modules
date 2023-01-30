module namespace {
  source = "../../namespace"
  region_name = var.region_name
  region_code = var.region_code
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  solution_name = var.solution_name
  solution_stage = var.solution_stage
  solution_fqn = var.solution_fqn
  aks_cluster_id = var.aks_cluster_id
  common_tags = local.module_common_tags
  kubernetes_namespace_name = "aad-pod-identity"
  istio_injection_enabled = false
  network_policy_enforced = false
}