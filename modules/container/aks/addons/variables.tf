variable "region_name" {
  description = "The Azure region to deploy into."
  type        = string
}

variable "region_code" {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name)."
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

variable "aks_cluster_id" {
  description = "Unique identifier of the target AKS cluster"
  type        = string
}

variable "kubernetes_cluster_architecture" {
  description = "Processor architecture of the worker nodes of the target AWS EKS cluster; allowed values are: `X86_64` (default), `ARM_64`"
  type        = string
  validation {
    condition     = var.kubernetes_cluster_architecture == "X86_64" || var.kubernetes_cluster_architecture == "ARM_64"
    error_message = "The kubernetes_cluster_architecture must be either `X86_64` (Intel-based 64 bit) or `ARM_64` (ARM-based 64 bit)"
  }
}

variable "public_dns_zone_id" {
  description = "Unique identifier of a public DNS supposed contain all public DNS records to route traffic to the Kubernetes cluster"
  type        = string
}

variable "addon_azure_storage_classes_enabled" {
  description = "controls if the additional Azure specific storage classes are installed on the given AKS cluster"
  type        = bool
  default     = true
}

variable "key_vault_id" {
  description = "Unique identifier of the Key Vault managing all confidential data of this solution"
  type        = string
}

variable "addon_cert_manager_enabled" {
  description = "controls if the Kubernetes cert-manager is installed on the given AKS cluster"
  type        = bool
  default     = true
}

variable "letsencrypt_account_name" {
  description = "Lets Encrypt Account name to be used to request certificates"
  type        = string
}

variable "addon_ingress_azure_enabled" {
  description = "Controls if addon `ingress_azure` should be enabled; default `true`"
  type        = bool
  default     = true
}

variable "loadbalancer_id" {
  description = "Unique identifier of an existing load balancer the ingress controllers are supposed to use; required if `addon_ingress_azure_enabled` is `true`"
  type        = string
  default     = ""
}

variable "addon_ingress_nginx_enabled" {
  description = "Controls if addon `ingress_nginx` should be enabled; default `true`"
  type        = bool
  default     = true
}

variable "addon_eck_operator_enabled" {
  description = "Controls if addon `eck_operator` should be enabled; default `false`"
  type        = bool
  default     = true
}

variable "opentelemetry_enabled" {
  description = "Controls if OpenTelemetry support should be enabled"
  type        = bool
  default     = false
}

variable "opentelemetry_collector_host" {
  description = "Host name of the OpenTelemetry collector endpoint; required if `opentelemetry_enabled` is true"
  type        = string
  default     = ""
}

variable "opentelemetry_collector_port" {
  description = "Port number of the OpenTelemetry collector endpoint; required if `opentelemetry_enabled` is true"
  type        = number
  default     = 0
}

variable "node_group_workload_class" {
  description = "Class of the AKS node group this tool stack should be hosted on"
  type        = string
  default     = ""
}

variable "host_names" {
  description = "Host names of all hosts whose traffic should be routed to this solution"
  type        = list(string)
  default     = []
}
