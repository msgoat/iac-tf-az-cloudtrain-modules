locals {
  control_plan_identity_name = "id-${var.region_code}-${var.solution_fqn}-${var.cluster_name}-aks-controlplane"
}
# create a user managed identity for the AKS cluster
resource azurerm_user_assigned_identity control_plane {
  name = local.control_plan_identity_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  tags = merge({ Name = local.control_plan_identity_name }, local.module_common_tags)
}

# allow managed identity for AKS cluster to access network resources hosting the AKS cluster to allow AKS to create an internal load balancer
resource azurerm_role_assignment vnet_owner {
  principal_id = azurerm_user_assigned_identity.control_plane.principal_id
  role_definition_name = "Owner"
  scope = data.azurerm_virtual_network.vnet_owner_scope.id
}

# allow managed identity for AKS cluster to contribute to resource group containing the cluster and potentially associated disk encryption sets
resource azurerm_role_assignment resource_group_contributor {
  principal_id = azurerm_user_assigned_identity.control_plane.principal_id
  role_definition_name = "Contributor"
  scope = data.azurerm_resource_group.resource_group_scope.id
}

# allow managed identity for AKS cluster to enable updated Container Insights metrics
# this role assignment is scoped on the cluster so if must be created after the cluster is present
resource azurerm_role_assignment monitoring_metrics_publisher {
  principal_id = azurerm_user_assigned_identity.control_plane.principal_id
  role_definition_name = "Monitoring Metrics Publisher"
  scope = azurerm_kubernetes_cluster.cluster.id
}

# create explicit dependency to wait on until role assignment is done
resource null_resource wait_for_role_assignments_to_control_plane {
  triggers = {
    vnet_owner_role_assignment_id = azurerm_role_assignment.vnet_owner.id
    resource_group_contributor_role_assignment_id = azurerm_role_assignment.resource_group_contributor.id
  }
}

data azurerm_virtual_network vnet_owner_scope {
  name = var.vnet_name
  resource_group_name = var.resource_group_name
}

data azurerm_resource_group resource_group_scope {
  name = var.resource_group_name
}