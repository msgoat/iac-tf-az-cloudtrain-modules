# retrieve the external loadbalancer managed by the AKS cluster
data azurerm_lb external {
  name = "kubernetes"
  resource_group_name = azurerm_kubernetes_cluster.cluster.node_resource_group
}