variable region_name {
  description = "The Azure region to deploy into."
  type = string
}

variable region_code {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
  type = string
}

variable common_tags {
  description = "Map of common tags to be attached to all managed Azure resources"
  type = map(string)
}

variable solution_name {
  description = "Name of this Azure solution"
  type = string
}

variable solution_stage {
  description = "Stage of this Azure solution"
  type = string
}

variable solution_fqn {
  description = "Fully qualified name of this Azure solution"
  type = string
}

variable resource_group_name {
  description = "The name of the resource group supposed to own all allocated resources"
  type = string
}

variable resource_group_location {
  description = "The location of the resource group supposed to own all allocated resources"
  type = string
}

variable cluster_name {
  description = "Name of the AKS cluster; will be transformed into a fully qualified AKS cluster name"
  type = string
}

variable kubernetes_version {
  description = "Kubernetes version the AKS service instance should be based on"
  type = string
}

variable loadbalancer_subnet_id {
  description = "Unique identifier of the internal loadbalancer subnet"
  type = string
}

variable vnet_name {
  description = "Name of the VNet which hosts the AKS cluster."
  type = string
}

variable aks_dns_service_ip {
  description = "IP address used for Kubernetes DNS service on each worker node"
  type = string
}

variable aks_docker_bridge_cidr {
  description = "CIDR used as the Docker bridge IP address on worker nodes"
  type = string
}

variable aks_pod_cidr {
  description = "CIDR used for virtual pod IP addresses"
  type = string
}

variable aks_service_cidr {
  description = "CIDR used for ClusterIP Kubernetes services"
  type = string
}

variable aks_addon_dashboard_enabled {
  description = "Enables the Kubernetes dashboard add-on"
  type = bool
  default = false
}

variable aks_addon_oms_agent_enabled {
  description = "Enables the Kubernetes OMS agent add-on"
  type = bool
  default = false
}

variable aks_addon_azure_policy_enabled {
  description = "Enables the Kubernetes Azure Policy add-on"
  type = bool
  default = false
}

variable aks_addon_aad_rbac_enabled {
  description = "Enables the Azure AD add-on for Kubernetes RBAC"
  type = bool
  default = false
}

variable aks_addon_aad_rbac_admin_group_ids {
  description = "List of Azure AD group object IDs whose members are allowed to administrate the AKS cluster"
  type = list(string)
  default = []
}

variable key_vault_id {
  description = "Unique identifier the common key vault instance used by this solution."
  type = string
}

variable log_analytics_workspace_id {
  description = "Unique identifier of the log analytics workspace; only required if azure_monitoring_enabled == true"
  type = string
  default = ""
}

variable container_registry_id {
  description = "Unique identifier of the Azure Container registry used to pull Docker images for AKS workload"
  type = string
}

variable aks_disk_encryption_enabled {
  description = "Enables encryption of OS disks and persistent volumes with customer-managed keys"
  type = bool
  default = false
}

variable azure_monitor_enabled {
  description = "Enables Azure Monitor with Container Insights on the AKS cluster"
  type = bool
  default = false
}

variable node_pools {
  description = "Information about node pools to be added to the AKS cluster; must contain at least on with role system"
  type = list(object({
    name = string
    role = string
    vm_sku = string
    max_size = number
    min_size = number
    desired_size = number
    max_surge = string
    kubernetes_version = string
    os_disk_size = number
    subnet_id = string
    labels = map(string)
    taints = list(string)
  }))
}

variable aks_admin_group_object_ids {
  description = "Object IDs of Azure AD groups whose members are cluster admins"
  type = list(string)
}

variable diagnostic_settings {
  description = "Configuration of the diagnostic settings applied to the AKS cluster; only effective if azure_monitor_enabled is `true`"
  type = object({
    retention_days = number
    logs = list(string)
    metrics = list(string)
  })
  default = {
    retention_days = 7
    logs = [
      "Kubernetes API Server",
      "Kubernetes Audit",
      "Kubernetes Audit Admin Logs",
      "Kubernetes Controller Manager",
      "Kubernetes Cluster Autoscaler",
      "Kubernetes Cloud Controller Manager",
      "guard",
      "csi-azuredisk-controller",
      "csi-azurefile-controller",
      "csi-snapshot-controller"
    ]
    metrics = [
      "AllMetrics"
    ]
  }
}

variable aks_addon_agic_enabled {
  description = "Enables the Azure Application Gateway Ingress Controller"
  type = bool
  default = false
}

variable "aks_addon_agic_application_gateway_name" {
  description = "Name of the Application Gateway in front of AKS; only required if `aks_addon_agic_enabled` is true"
  type = string
  default = ""
}

variable "aks_addon_agic_application_gateway_id" {
  description = "Unique identifier of the Application Gateway in front of AKS; only required if `aks_addon_agic_enabled` is true"
  type = string
  default = ""
}

variable "aks_addon_agic_application_gateway_subnet_id" {
  description = "Unique identifier of the subnet supposed to host or hosting the Application Gateway in front of AKS; only required if `aks_addon_agic_enabled` is true."
  type = string
  default = ""
}

