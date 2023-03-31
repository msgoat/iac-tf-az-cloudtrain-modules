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

variable "key_vault_name" {
  description = "Logical name of the Key Vault, will become part of the fully qualified name of the Key Vault"
  type        = string
}

variable "key_vault_sku" {
  description = "SKU of the Key Vault, possible values are `standard` and `premium`; default: `standard`"
  type        = string
  default     = "standard"
}

variable "key_vault_admin_group_ids" {
  description = "Unique identifiers of Azure AD groups which grant its members access to this Key Vault"
  type        = list(string)
  default     = []
}

variable "soft_delete_retention_days" {
  description = "Number of days deleted secrets, certificates and keys are retained; default: 7"
  type        = number
  default     = 7
}