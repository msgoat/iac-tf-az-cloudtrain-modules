variable "region_name" {
  description = "The Azure region to deploy into."
  type        = string
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
  description = "Fully qualified name of this Azure solution (usually: <solution_name>-<solution_stage>)"
  type        = string
}

variable "common_tags" {
  description = "Map of common tags to be attached to all managed Azure resources"
  type        = map(string)
}

variable "resource_group_id" {
  description = "Unique identifier of the resource group supposed to own all allocated resources"
  type        = string
}

variable "dns_zone_name" {
  description = "Name of the public DNS zone to create"
  type        = string
}

variable "parent_dns_zone_id" {
  description = "Optional unique identifier of a public parent DNS zone the newly created DNS zone should be linked with"
  type        = string
  default     = ""
}
