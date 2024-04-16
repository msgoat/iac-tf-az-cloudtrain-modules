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
  description = "Unique identifier of the resource group supposed to own all allocated resources"
  type = string
}

variable db_instance_name {
  description = "Logical name of the PostgreSQL instance"
  type = string
}

variable db_instance_sku {
  description = "Instance type of virtual machine running the PostgreSQL instance"
  type = string
}

variable db_min_storage_size {
  description = "Minimum storage size of the PostgreSQL instance in megabytes; default 20GB"
  type = number
  default = 20480
}

variable db_max_storage_size {
  description = "Maximum storage size of the PostgreSQL instance in megabytes; default 100GB"
  type = number
  default = 102400
}

variable db_autogrow_enabled {
  description = "Storage of database server can grow automatically, if set"
  type = bool
  default = false
}

variable db_backup_retention_days {
  description = "Number of days backups are retained"
  type = number
  default = 7
}

variable postgresql_version {
  description = "PostgreSQL version"
  type = string
  default = "15"
}

variable public_access_enabled {
  description = "Controls if public network access is allowed for this server"
  type = bool
  default = true
}

variable allow_public_access_from_ips {
  description = "IP addresses which are allowed to connect to PostgreSQL using public access"
  type = list(string)
}

variable ssl_enforcement_enabled {
  description = "Controls if TLS should be enforced on connections"
  type = bool
  default = true
}

variable db_encryption_enabled {
  description = "Enables encryption of PostgreSQL storage with customer-managed keys"
  type = bool
  default = true
}

variable key_vault_id {
  description = "Unique identifier of a Key Vault instance supposed to manage all secrets and encryption keys"
  type = string
}





