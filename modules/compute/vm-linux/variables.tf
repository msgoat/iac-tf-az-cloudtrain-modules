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

variable "virtual_machine_name" {
  description = "Logical name of this virtual machine, will become part of the fully qualified name"
  type        = string
}

variable "virtual_machine_size" {
  description = "VM size of the virtual machine"
  type        = string
}

variable "subnet_id" {
  description = "Unique identifier of the subnet hosting the newly created virtual machine"
  type        = string
}

variable "key_vault_id" {
  description = "Unique identifier the common key vault instance used by this solution."
  type        = string
}

variable "cmk_encryption_enabled" {
  description = "Controls if customer-managed keys stored in Key Vault should be used to encrypt volumes"
  type        = bool
  default     = false
}

variable "public_access_enabled" {
  description = "Controls if the virtual machine should be publicly accessible (i.e. get a public IP address)"
}