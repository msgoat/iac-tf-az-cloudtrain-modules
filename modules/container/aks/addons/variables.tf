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

variable "key_vault_id" {
  description = "Unique identifier of the Key Vault managing all confidential data of this solution"
  type        = string
}

variable "addon_cert_manager_enabled" {
  description = "controls if the Kubernetes cert-manager is installed on the given AKS cluster"
  type        = bool
  default     = true
}

variable "addon_azure_storage_classes_enabled" {
  description = "controls if the additional Azure specific storage classes are installed on the given AKS cluster"
  type        = bool
  default     = true
}

variable "node_group_workload_class" {
  description = "Class of the AKS node group this tool stack should be hosted on"
  type        = string
  default     = ""
}

variable "dns_zone_id" {
  description = "Unique identifier of a public DNS supposed contain all public DNS records to route traffic to the Kubernetes cluster"
  type        = string
}

variable "letsencrypt_account_name" {
  description = "Lets Encrypt Account name to be used to request certificates"
  type        = string
}

variable "application_gateway_id" {
  description = "Unique identifier of the application gateway supposed to route traffic to the Kubernetes cluster"
  type        = string
}