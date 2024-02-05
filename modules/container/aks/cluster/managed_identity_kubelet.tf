# Create a managed identify for kubelet and assigns additional roles
locals {
  kubelet_identity_name = "id-${var.region_code}-${var.solution_fqn}-${var.kubernetes_cluster_name}-aks-kubelet"
}

# create managed identity for kubelet
resource azurerm_user_assigned_identity kubelet {
  name = local.kubelet_identity_name
  resource_group_name = data.azurerm_resource_group.given.name
  location = var.region_name
  tags = merge({ Name = local.kubelet_identity_name }, local.module_common_tags)
}

data azurerm_resource_group cluster_resource_group {
  name = azurerm_kubernetes_cluster.cluster.resource_group_name
}

data azurerm_resource_group node_resource_group {
  name = azurerm_kubernetes_cluster.cluster.node_resource_group
}

# allow AKS managed identity for kubelet to manage managed identities of node resource group
resource azurerm_role_assignment managed_identity_operator_on_nodes {
  principal_id = azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name = "Managed Identity Operator"
  scope = data.azurerm_resource_group.node_resource_group.id
}

# allow AKS managed identity for kubelet to manage managed identities of cluster resource group
resource azurerm_role_assignment managed_identity_operator_on_cluster {
  principal_id = azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name = "Managed Identity Operator"
  scope = data.azurerm_resource_group.cluster_resource_group.id
}

# allow AKS managed identity for kubelet to manage virtual machines in node resource group
resource azurerm_role_assignment virtual_machine_contributor {
  principal_id = azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name = "Virtual Machine Contributor"
  scope = data.azurerm_resource_group.node_resource_group.id
}

# allow AKS managed identity for kubelet to pull docker images from ACR
resource azurerm_role_assignment acr_pull {
  count = var.container_registry_id != "" ? 1 : 0
  principal_id = azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name = "AcrPull"
  scope = var.container_registry_id
}

# create sync point for all role assignments
resource null_resource wait_for_role_assignments_to_kubelet {
  triggers = {
    operator_on_cluster_role_assignment_id = azurerm_role_assignment.managed_identity_operator_on_cluster.id
    operator_on_nodes_role_assignment_id = azurerm_role_assignment.managed_identity_operator_on_nodes.id
    virtual_machine_contributor_role_assignment_id = azurerm_role_assignment.virtual_machine_contributor.id
  }
}
