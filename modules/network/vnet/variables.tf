variable "region_name" {
  description = "The Azure region to deploy into."
  type        = string
}

variable "region_code" {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
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

variable "network_name" {
  description = "Logical name of the VNet (will become part of the canonical name of the VNet)"
  type        = string
}

variable "network_cidr" {
  description = "CIDR block of the network"
  type        = string
}

variable "nat_strategy" {
  description = "NAT strategy to be applied to the VNet. Possible values are: NAT_NONE (no NAT gateways), NAT_GATEWAY_SINGLE (one NAT gateway for all AZs) or NAT_GATEWAY_AZ (one NAT gateway per AZ)"
  type        = string
  default     = "NAT_NONE"
}

variable "subnet_templates" {
  description = "Templates for subnets to be created"
  type = list(object({
    name          = string      # subnet template name
    accessibility = string      # accessibility of the subnet ("public" or "private")
    role          = string      # role or responsibility of the subnet; can be used to find all subnets with matching roles
    newbits       = number      # additional bits to extend the prefix of this subnet
  }))
}
