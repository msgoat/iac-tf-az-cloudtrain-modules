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

variable addon_enabled {
  description = "controls if this addon should be installed on the target AKS cluster"
  type = bool
  default = true
}

variable aks_cluster_id {
  description = "Unique identifier of the AKS cluster"
  type = string
}

variable kubernetes_namespace_name {
  description = "Name of the Kubernetes namespace supposed to host the cert manager"
  type = string
  default = "cert-manager"
}

variable helm_release_name {
  description = "Name of the Helm release used to deploy the cert manager"
  type = string
  default = "cert-manager"
}

variable node_group_workload_class {
  description = "Class of the AKS node group this tool stack should be hosted on"
  type = string
  default = ""
}
