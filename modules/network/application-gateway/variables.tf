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

variable agw_subnet_id {
  description = "Unique identifier of the application gateway subnet"
  type = string
}

variable application_gateway_name {
  description = "Logical name of this application gateway"
  type = string
}

variable agw_host_names {
  description = "Host names to route through the application gateway; may contain wildcard domains"
  type = list(string)
}

variable aks_ingress_controller_name {
  description = "Name of the ingress controller"
  type = string
}

variable aks_ingress_controller_protocol {
  description = "Protocol to route traffic to the ingress controller; may be http or https"
  type = string
}

variable aks_ingress_controller_port {
  description = "Port number to route traffic to ingress controller"
  type = number
}

variable aks_ingress_controller_dns {
  description = "DNS name of the AKS ingress controller"
  type = string
  default = ""
}

variable aks_ingress_controller_ip {
  description = "IP address of the AKS ingress controller"
  type = string
}

variable aks_ingress_controller_timeout {
  description = "Time out of ingress controller in seconds"
  type = number
  default = 30
}

variable aks_ingress_controller_probe_protocol {
  description = "Protocol for health checks on the AKS ingress controller; may be http or https"
  type = string
}

variable aks_ingress_controller_probe_port {
  description = "Port number for health checks on the AKS ingress controller"
  type = number
}

variable aks_ingress_controller_probe_path {
  description = "URI for health checks on the AKS ingress controller"
  type = string
}

variable aks_ingress_controller_probe_status_codes {
  description = "Expected HTTP status codes for health checks on the AKS ingress controller"
  type = list(number)
  default = [200, 404]
}

variable key_vault_id {
  description = "Unique identifier of the shared key vault instance."
  type = string
}

variable agw_min_capacity {
  description = "Minimum capacity for autoscaling of the application gateway"
  type = number
  default = 2
}

variable agw_max_capacity {
  description = "Maximum capacity for autoscaling of the application gateway"
  type = number
  default = 4
}

variable agw_key_vault_certificate_name {
  description = "Name of the application gateway certificate managed by the given key vault"
  type = string
  default = ""
}

variable agw_monitoring_enabled {
  description = "Controls if monitoring for the application gateway should be enabled; default: true"
  type = bool
  default = true
}

variable log_analytics_workspace_id {
  description = "Unique name of the shared log analytics workspace; only required if agw_monitoring_enabled == true"
  type = string
  default = ""
}

variable public_dns_zone_id {
  description = "Unique identifier of the public DNS zone supposed to host all public DNS records pointing to this application gateway"
  type = string
}

