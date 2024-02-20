variable "region_name" {
  description = "The Azure region to deploy into."
  type        = string
}

variable "region_code" {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
  type        = string
}

variable "common_tags" {
  description = "Map of common tags to be attached to all managed Azure resources"
  type        = map(string)
}

variable "solution_name" {
  description = "Name of this Azure solution"
  type        = string
}

variable "solution_stage" {
  description = "Stage of this Azure solution"
  type        = string
}

variable "solution_fqn" {
  description = "Fully qualified name of this Azure solution"
  type        = string
}

variable "resource_group_id" {
  description = "Unique identifier name of the resource group supposed to own all allocated resources"
  type        = string
}

variable "kubernetes_cluster_name" {
  description = "Name of the AKS cluster; will be transformed into a fully qualified AKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version the AKS service instance should be based on"
  type        = string
}

variable "kubernetes_api_access_cidrs" {
  description = "CIDR blocks defining source API ranges allowed to access the Kubernetes API"
  type        = list(string)
}

variable "names_of_zones_to_span" {
  description = "Names of availability zones the AKS cluster is supposed to span"
  type        = list(string)
}

variable "loadbalancer_subnet_id" {
  description = "Unique identifier of the internal loadbalancer subnet"
  type        = string
}

variable "vnet_id" {
  description = "Name of the VNet which hosts the AKS cluster."
  type        = string
}

variable "aks_dns_service_ip" {
  description = "IP address used for Kubernetes DNS service on each worker node"
  type        = string
  default     = "172.29.0.17"
}

variable "aks_docker_bridge_cidr" {
  description = "CIDR used as the Docker bridge IP address on worker nodes"
  type        = string
  default     = "172.27.0.1/16"
}

variable "aks_service_cidr" {
  description = "CIDR used for ClusterIP Kubernetes services"
  type        = string
  default     = "172.29.0.0/16"
}

variable "aks_addon_dashboard_enabled" {
  description = "Enables the Kubernetes dashboard add-on"
  type        = bool
  default     = false
}

variable "aks_addon_oms_agent_enabled" {
  description = "Enables the Kubernetes OMS agent add-on"
  type        = bool
  default     = false
}

variable "aks_addon_azure_policy_enabled" {
  description = "Enables the Kubernetes Azure Policy add-on"
  type        = bool
  default     = false
}

variable "aks_addon_aad_rbac_enabled" {
  description = "Enables the Azure AD add-on for Kubernetes RBAC"
  type        = bool
  default     = false
}

variable "aks_addon_aad_rbac_admin_group_ids" {
  description = "List of Azure AD group object IDs whose members are allowed to administrate the AKS cluster"
  type        = list(string)
  default     = []
}

variable "key_vault_id" {
  description = "Unique identifier the common key vault instance used by this solution."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Unique identifier of the log analytics workspace; only required if azure_monitoring_enabled == true"
  type        = string
  default     = ""
}

variable "container_registry_id" {
  description = "Unique identifier of the Azure Container registry used to pull Docker images for AKS workload"
  type        = string
  default     = ""
}

variable "azure_monitor_enabled" {
  description = "Enables Azure Monitor with Container Insights on the AKS cluster"
  type        = bool
  default     = false
}

variable "encryption_at_host_enabled" {
  description = "Controls if encryption at host should be enabled on all AKS worker nodes (default: true). Attention: current subscription must support it!"
  type        = bool
  default     = true
}

variable "node_pool_templates" {
  description = "Information about node pools to be added to the AKS cluster; must contain at least one with role system"
  type = list(object({
    enabled            = optional(bool, true)      # controls if this node group gets actually created
    managed            = optional(bool, true)      # controls if this node group is a managed or unmanaged node group
    name               = string                    # logical name of this nodegroup
    role               = string                    # role of the node group; must be either "user" or "system"
    kubernetes_version = optional(string, null)    # Kubernetes version of this node group; will default to kubernetes_version of the cluster, if not specified but may differ from kubernetes_version during cluster upgrades
    min_size           = number                    # minimum size of this node group
    max_size           = number                    # maximum size of this node group
    desired_size       = optional(number, 0)       # desired size of this node group; will default to min_size if set to 0
    disk_size          = number                    # size of attached root volume in GB
    capacity_type      = string                    # defines the purchasing option for the EC2 instances in all node groups
    instance_type      = string                    # virtual machine instance type which should be used for the AWS EKS worker node groups ordered descending by preference
    labels             = optional(map(string), {}) # Kubernetes labels to be attached to each worker node
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])                                    # Kubernetes taints to be attached to each worker node
    image_type = optional(string, "AL2_x86_64") # Type of OS images to be used for EC2 instances; possible values are: AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 | BOTTLEROCKET_x86_64 | BOTTLEROCKET_ARM_64_NVIDIA | BOTTLEROCKET_x86_64_NVIDIA; default is "AL2_x86_64"
  }))

}

variable "system_pool_subnet_id" {
  description = "Unique identifier of the subnet used for all system pool templates, if not specified in the template"
  type        = string
  default     = ""
}

variable "user_pool_subnet_id" {
  description = "Unique identifier of the subnet used for all user pool templates, if not specified in the template"
  type        = string
  default     = ""
}

variable "diagnostic_settings" {
  description = "Configuration of the diagnostic settings applied to the AKS cluster; only effective if azure_monitor_enabled is `true`"
  type = object({
    retention_days = number
    logs           = list(string)
    metrics        = list(string)
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

variable "aks_addon_agic_enabled" {
  description = "Enables the Azure Application Gateway Ingress Controller"
  type        = bool
  default     = true
}

variable "aks_addon_agic_application_gateway_id" {
  description = "Unique identifier of the Application Gateway in front of AKS; only required if `aks_addon_agic_enabled` is true"
  type        = string
  default     = ""
}

