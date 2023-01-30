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

variable key_vault_id {
  description = "Unique identifier of the shared Key Vault"
  type = string
}

variable kubernetes_namespace_name {
  description = "Name of the Kubernetes namespace supposed to host Grafana"
  type = string
  default = "tracing"
}

variable helm_release_name {
  description = "Name of the Helm release used to deploy Grafana"
  type = string
  default = "tracing"
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

variable topology_spread_strategy {
  description = "Strategy to use regarding distribution of pod replicas across node / availability zones; possible values are: none, soft and hard"
  type = string
  default = "hard"
}
