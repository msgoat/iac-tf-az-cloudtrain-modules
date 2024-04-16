locals {
  secret_name = "grafana-${var.solution_fqn}-${random_uuid.secret_suffix.result}"
  secret_value = {
    grafana-admin-user = random_string.grafana_admin.result
    grafana-admin-password = random_password.grafana_admin.result
  }
}

# create a Key Vault secret to hold Grafana admin username and password
resource azurerm_key_vault_secret grafana {
  name = local.secret_name
  tags = merge({ Name = local.secret_name }, local.module_common_tags)
  key_vault_id = var.key_vault_id
  value = jsonencode(local.secret_value)
}

resource random_uuid secret_suffix {

}