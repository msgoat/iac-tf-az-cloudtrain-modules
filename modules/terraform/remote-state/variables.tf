variable region_name {
  description = "Name of an Azure region that hosts this solution (like West Europe)"
  type = string
}

variable region_code {
  description = "Code of an Azure region that hosts this solution (like westeu for West Europe)"
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
  description = "Fully qualified name of this Azure solution"
  type = string
}

variable common_tags {
  description = "Map of common tags to be attached to all managed Azure resources"
  type = map(string)
}

variable "backend_name" {
  description = "Name of the Terraform backend"
  type        = string
  default     = "terraform"
}