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

variable log_analytics_workspace_id {
  description = "Unique identifier of the log analytics workspace"
  type = string
}

variable app_insights_daily_data_limit {
  description = "Maximum amount of data you want to collect per day in GB; interpreted as no limit if set to 0"
  type = number
  default = 5
}

variable app_insights_retention {
  description = "Number of days all data stored in Application Insights is retained"
  type = number
  default = 30
}

variable aks_cluster_id {
  description = "Unique identifier of the AKS cluster; must be specified"
  type = string
}

variable kubernetes_namespace_names {
  description = "Names of Kubernetes namespaces the secret should be added to"
  type = list(string)
  default = []
}
