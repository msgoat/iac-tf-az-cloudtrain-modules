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
  description = "name of the Kubernetes namespace"
  type = string
}

variable istio_injection_enabled {
  description = "controls if Istio sidecar injection should be enabled on this namespace"
  type = bool
  default = true
}

variable network_policy_enforced {
  description = "adds a network policy blocking any inbound traffic, thus enforcing each deployment to provide a network policy"
  type = bool
  default = true
}

variable create_namespace {
  description = "controls if this module actually creates a namespace; set to false to deactivate this module"
  type = bool
  default = true
}
