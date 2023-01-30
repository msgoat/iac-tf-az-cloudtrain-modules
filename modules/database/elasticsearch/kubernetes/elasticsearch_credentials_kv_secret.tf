locals {
  key_vault_secret_name = "es-${var.region_code}-${var.solution_fqn}-${var.elasticsearch_cluster_name}-${random_uuid.key_vault_secret_name_suffix.result}"
}

# create a Key Vault secret with username and password of PostgreSQL admin user
resource azurerm_key_vault_secret elasticsearch {
  key_vault_id = data.azurerm_key_vault.shared.id
  name = local.key_vault_secret_name
  value = jsonencode({
    username = local.es_default_user
    password = random_password.password.result
  })
  content_type = "application/json"
  tags = merge({ Name = local.key_vault_secret_name, RefersTo = "es-${var.region_code}-${var.solution_fqn}-${var.elasticsearch_cluster_name}"}, local.module_common_tags)
}

# since we have purge protection enabled on Key Vault we have make secret names unique with a random suffix
resource random_uuid key_vault_secret_name_suffix {
}
