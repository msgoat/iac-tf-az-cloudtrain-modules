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

variable resource_group_name {
  description = "The name of the resource group supposed to own all allocated resources"
  type = string
}

variable resource_group_location {
  description = "The location of the resource group supposed to own all allocated resources"
  type = string
}

variable common_tags {
  description = "Map of common tags to be attached to all managed Azure resources"
  type = map(string)
}

variable db_instance_name {
  description = "Logical name of the Redis instance"
  type = string
}

variable db_database_name {
  description = "Name of the database to create within the Redis instance"
  type = string
}

variable db_instance_sku {
  description = "SKU (plus family plus capacity) of the Redis server (i.e. Standard_C0 for SKU Standard, family C and capacity 0)"
  type = string
  default = "Standard_C0"
}

variable db_min_storage_size {
  description = "Minimum storage size of the Redis instance in megabytes; default 20GB"
  type = number
  default = 20480
}

variable db_max_storage_size {
  description = "Maximum storage size of the Redis instance in megabytes; default 100GB"
  type = number
  default = 102400
}

variable public_access_enabled {
  description = "Controls if public network access is allowed for this server"
  type = bool
  default = false
}

variable allow_public_access_from_ips {
  description = "IP addresses which are allowed to connect to Redis using public access"
  type = list(string)
}

variable ssl_enforcement_enabled {
  description = "Controls if TLS should be enforced on connections"
  type = bool
  default = true
}

variable key_vault_id {
  description = "Unique identifier of a Key Vault instance supposed to manage all secrets and encryption keys"
  type = string
}

variable private_endpoint_enabled {
  description = "Feature toggle for the creation of a private endpoint"
  type = bool
  default = false
}

variable private_endpoint_subnet_id {
  description = "Unique identifier of a subnet which is supposed to host the private endpoints to Azure Redis server; must be specified, if private_endpoint_enabled is true."
  type = string
  default = ""
}

variable private_endpoint_dns_zone_resource_group_name {
  description = "Name of the resource group owning the private DNS zone for private endpoints to Azure Redis server; must be specified, if private_endpoint_enabled is true."
  type = string
  default = ""
}

variable kubernetes_secret_enabled {
  description = "Feature toggle for the creation of Kubernetes secrets"
  type = bool
  default = false
}

variable aks_cluster_id {
  description = "Unique identifier of the AKS cluster; must be specified, if kubernetes_secret_enabled is true"
  type = string
  default = ""
}

variable kubernetes_namespace_names {
  description = "Names of Kubernetes namespaces the secret should be added to; must be specified, if kubernetes_secret_enabled is true"
  type = list(string)
  default = []
}




