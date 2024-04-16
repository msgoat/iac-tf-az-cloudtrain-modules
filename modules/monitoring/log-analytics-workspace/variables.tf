variable region_name {
  description = "The Azure region to deploy into."
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

variable workspace_name {
  description = "Logical name of the log analytics workspace"
  type = string
}

variable log_analytics_workspace_sku {
  description = "SKU of the log analytics workspace"
  type = string
  default = "PerGB2018"
}

variable log_analytics_workspace_retention {
  description = "Retention in days of data stored in the log analytics workspace (min 30)"
  type = number
  default = 30
}

variable log_analytics_workspace_daily_data_limit {
  description = "Maximum amount of data you want to collect per day in GB; interpreted as no limit if set to 0"
  type = number
  default = 5
}


