locals {
  aks_cluster_id_parts = split("/", var.aks_cluster_id)
  aks_cluster_name = local.aks_cluster_id_parts[8]
  aks_cluster_resource_group_name = local.aks_cluster_id_parts[4]
  aks_cluster_subscription = local.aks_cluster_id_parts[2]
}

# retrieve target AKS cluster if we need to add Kubernetes secrets for PostgreSQL
data azurerm_kubernetes_cluster cluster {
  name = local.aks_cluster_name
  resource_group_name = local.aks_cluster_resource_group_name
}
