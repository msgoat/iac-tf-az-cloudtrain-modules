variable region_name {
  description = "The Azure region to deploy into."
  type = string
}

variable region_code {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name)."
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
  description = "Name of the resource group to own all resources of this environment"
  type = string
}

variable resource_group_location {
  description = "Location of the resource group to own all resources of this environment; assumed to be region_name if left empty"
  type = string
  default = ""
}

variable aks_cluster_id {
  description = "Unique identifier of the target AKS cluster"
  type = string
}

variable addon_aad_pod_identity_enabled {
  description = "controls if the Azure AD Pod Identity addon is installed on the given AKS cluster"
  type = bool
}

variable addon_cert_manager_enabled {
  description = "controls if the Kubernetes cert-manager is installed on the given AKS cluster"
  type = bool
}

variable addon_azure_storage_classes_enabled {
  description = "controls if the additional Azure specific storage classes are installed on the given AKS cluster"
  type = bool
}

variable aks_disk_encryption_set_id {
  description = "Unique identifier of the Azure Disk Encryption Set managing disk encryption with a customer managed key"
  type = string
}

variable node_group_workload_class {
  description = "Class of the AKS node group this tool stack should be hosted on"
  type = string
  default = ""
}
