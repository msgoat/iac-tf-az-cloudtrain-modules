variable region_name {
  description = "The Azure region to deploy into."
  type = string
}

variable region_code {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
  type = string
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
  description = "Fully qualified name of this Azure solution (usually: <solution_name>-<solution_stage>)"
  type = string
}

variable common_tags {
  description = "Map of common tags to be attached to all managed Azure resources"
  type = map(string)
}

variable resource_group_id {
  description = "The unique identifier of the resource group supposed to own all allocated resources"
  type = string
}

variable network_name {
  description = "Logical name of the VNet (will become part of the canonical name of the VNet)"
  type = string
}

variable network_cidr {
  description = "CIDR block of the network"
  type = string
}
