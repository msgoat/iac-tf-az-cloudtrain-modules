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

variable resource_group_id {
  description = "Unique identifier of the resource group supposed to own all allocated resources"
  type = string
}

variable aks_cluster_id {
  description = "Unique identifier of the AKS cluster"
  type = string
}

variable "kubernetes_namespace_templates" {
  description = "Templates for the Kubernetes namespaces to create"
  type = list(object({
    name                    = string
    labels                  = optional(map(string), {})
    network_policy_enforced = optional(bool, false)
  }))
}
