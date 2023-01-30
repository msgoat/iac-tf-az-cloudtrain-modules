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

variable aks_cluster_id {
  description = "Unique identifier of the AKS cluster"
  type = string
}

variable kubernetes_namespace_name {
  description = "Name of the Kubernetes namespace supposed to host Grafana"
  type = string
  default = "monitoring"
}

variable helm_release_name {
  description = "Name of the Helm release used to deploy Grafana"
  type = string
  default = "monitoring"
}

variable prometheus_storage_size {
  description = "Storage size allocated by each Prometheus instance in GB"
  type = number
  default = 32
}

variable prometheus_storage_sku {
  description = "Storage SKU allocated by each Prometheus instance; supported values are: Standard, Premium"
  type = string
  default = "Premium"
  validation {
    condition = var.prometheus_storage_sku == "Standard" || var.prometheus_storage_sku == "Premium"
    error_message = "Expected Standard or Premium storage SKU for each Prometheus instance."
  }
}

variable grafana_storage_size {
  description = "Storage size allocated by Grafana in GB"
  type = number
  default = 16
}

variable grafana_storage_class {
  description = "Kubernetes storage class of storage allocated by Grafana"
  type = string
  default = "managed-csi-premium"
}

variable ingress_host_name {
  description = "Hostname all ingresses should be referring to"
  type = string
}

variable node_group_workload_class {
  description = "Class of the AKS node group this tool stack should be hosted on"
  type = string
  default = ""
}

