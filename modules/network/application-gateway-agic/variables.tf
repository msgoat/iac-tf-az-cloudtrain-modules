variable "region_name" {
  description = "The Azure region to deploy into."
  type        = string
}

variable "region_code" {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
  type        = string
}

variable "common_tags" {
  description = "Map of common tags to be attached to all managed Azure resources"
  type        = map(string)
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
  description = "Fully qualified name of this Azure solution"
  type        = string
}

variable "resource_group_id" {
  description = "Unique identifier of the resource group supposed to own all allocated resources"
  type        = string
}

variable "subnet_id" {
  description = "Unique identifier of the subnets supposed to host the application gateway"
  type        = string
}

variable "application_gateway_name" {
  description = "Logical name of this application gateway"
  type        = string
}

variable "min_capacity" {
  description = "Minimum capacity for autoscaling of the application gateway"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum capacity for autoscaling of the application gateway"
  type        = number
  default     = 4
}

variable "monitoring_enabled" {
  description = "Controls if monitoring for the application gateway should be enabled; default: true"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Unique name of the shared log analytics workspace; only required if agw_monitoring_enabled == true"
  type        = string
  default     = ""
}

variable "public_dns_zone_id" {
  description = "Unique identifier of a public DNS supposed contain all public DNS records to route traffic to this application gateway"
  type        = string
}

variable "names_of_zones_to_span" {
  description = "Names of availability zones the application gateway is supposed to span"
  type        = list(string)
}


