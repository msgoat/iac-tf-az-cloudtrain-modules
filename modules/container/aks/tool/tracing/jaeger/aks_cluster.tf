locals {
  // /subscriptions/5945938d-2ee8-4229-ac6a-b0d1ff422981/resourceGroups/rg-westeu-echspltf-dev-stage/providers/Microsoft.ContainerService/managedClusters/aks-westeu-echspltf-dev
  aks_cluster_id_parts = split("/", var.aks_cluster_id)
  aks_cluster_name = local.aks_cluster_id_parts[8]
  aks_cluster_resource_group_name = local.aks_cluster_id_parts[4]
  aks_cluster_subscription = local.aks_cluster_id_parts[2]
}

data azurerm_kubernetes_cluster cluster {
  name = local.aks_cluster_name
  resource_group_name = local.aks_cluster_resource_group_name
}

locals {
  aks_host                   = data.azurerm_kubernetes_cluster.cluster.kube_admin_config.0.host
  aks_username               = data.azurerm_kubernetes_cluster.cluster.kube_admin_config.0.username
  aks_password               = data.azurerm_kubernetes_cluster.cluster.kube_admin_config.0.password
  aks_client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_admin_config.0.client_certificate)
  aks_client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_admin_config.0.client_key)
  aks_cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_admin_config.0.cluster_ca_certificate)
}
