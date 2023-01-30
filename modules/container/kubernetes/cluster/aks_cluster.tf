locals {
  aks_cluster_name = "aks-${var.region_code}-${var.solution_fqn}-${var.cluster_name}"
  node_resource_group_name = "rg-${var.region_code}-${var.solution_fqn}-${var.cluster_name}-nodes"
  aks_addon_oms_agent_enabled = var.azure_monitor_enabled
  default_node_pool_name = "aks-${var.region_code}-${var.solution_fqn}-${var.cluster_name}-system"
  system_pools = [for np in var.node_pools : np if np.role == "system"]
  disabled_agic_settings = []
  enabled_agic_settings = [
    {
      gateway_id = var.aks_addon_agic_application_gateway_id
      gateway_name = var.aks_addon_agic_application_gateway_id == "" ? var.aks_addon_agic_application_gateway_name : null
      subnet_id = var.aks_addon_agic_application_gateway_id == "" ? var.aks_addon_agic_application_gateway_subnet_id : null
    }
  ]
  agic_settings = var.aks_addon_agic_enabled ? local.enabled_agic_settings : local.disabled_agic_settings
}

# create a AKS cluster instance
resource azurerm_kubernetes_cluster cluster {
  name                = local.aks_cluster_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  # defines the system node pool
  dynamic "default_node_pool" {
    for_each = toset(local.system_pools)
    content {
      name                         = "system"
      vm_size                      = default_node_pool.value.vm_sku
      zones                        = ["1", "2", "3"]
      enable_auto_scaling          = true
      min_count                    = default_node_pool.value.min_size
      node_count                   = default_node_pool.value.desired_size
      max_count                    = default_node_pool.value.max_size
      enable_node_public_ip        = false
      orchestrator_version         = default_node_pool.value.kubernetes_version
      os_disk_size_gb              = default_node_pool.value.os_disk_size
      type                         = "VirtualMachineScaleSets"
      vnet_subnet_id               = default_node_pool.value.subnet_id
      only_critical_addons_enabled = true

      tags = merge({ Name = local.default_node_pool_name }, local.module_common_tags)
      upgrade_settings {
        max_surge = default_node_pool.value.max_surge
      }
    }
  }

  dns_prefix = local.aks_cluster_name

  api_server_authorized_ip_ranges = [ "0.0.0.0/0" ]

  automatic_channel_upgrade = "stable"

  auto_scaler_profile {
    expander = "least-waste"
    # TODO: complete block!
  }

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = var.aks_admin_group_object_ids
    azure_rbac_enabled = true
  }

  azure_policy_enabled = var.aks_addon_azure_policy_enabled

  # use disk encryption set if disk encryption is enabled
  disk_encryption_set_id = var.aks_disk_encryption_enabled ? azurerm_disk_encryption_set.cmk_disk_encryption[0].id : null

  http_application_routing_enabled = false

  identity {
    # we bring our own identity which has all required role assignments
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.control_plane.id ]
  }

  dynamic ingress_application_gateway {
    for_each = toset(local.agic_settings)
    content {
      gateway_id = ingress_application_gateway.value.gateway_id
      gateway_name = ingress_application_gateway.value.gateway_name
      subnet_id    = ingress_application_gateway.value.subnet_id
    }
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
    secret_rotation_interval = "2m"
  }
  # IMPORTANT: we need to pin the kubernetes version, otherwise Azure will determine it!
  kubernetes_version = var.kubernetes_version

  maintenance_window {
    # allow cluster maintenance on Thursday 4am
    allowed {
      day = "Thursday"
      hours = [ 4 ]
    }
  }

  network_profile {
    network_plugin = "azure"
    network_mode = "transparent"
    network_policy = "azure"
    # all internally used IP addresses and IP address ranges must be set as variables!!!
    dns_service_ip = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr = var.aks_service_cidr
    outbound_type = "loadBalancer"
    load_balancer_sku = "standard"
  }

  node_resource_group = local.node_resource_group_name
/*
  oms_agent {
    log_analytics_workspace_id = ""
    # TODO: complete block!
  }
*/
  public_network_access_enabled = true

  tags = merge({"Name" = local.aks_cluster_name}, local.module_common_tags)

  lifecycle {
    ignore_changes = [
      kubernetes_version, # kubernetes may be upgraded by azure cli or portal
      default_node_pool[0].orchestrator_version, # kubernetes may be upgraded by azure cli or portal
      default_node_pool[0].node_count, # node count may be changed by cluster autoscaler
      network_profile[0].load_balancer_profile[0].idle_timeout_in_minutes
    ]
  }
  # wait until the role assignment has been assigned to the AKS cluster identity
  depends_on = [null_resource.wait_for_role_assignments_to_control_plane]

}
