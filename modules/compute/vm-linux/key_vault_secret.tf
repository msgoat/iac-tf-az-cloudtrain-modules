locals {
  ssh_private_key_secret_name = "${local.virtual_machine_name}-ssh-private-${random_uuid.ssh_key_name_suffix.result}"
  ssh_public_key_secret_name  = "${local.virtual_machine_name}-ssh-public-${random_uuid.ssh_key_name_suffix.result}"
}

# create a Key Vault secret with the private SSH key
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = local.ssh_private_key_secret_name
  key_vault_id = data.azurerm_key_vault.shared.id
  value        = replace(tls_private_key.admin.private_key_pem, "/\n/", "\n")
  content_type = "application/x-pem-file"
  tags = merge({
    Name     = local.ssh_private_key_secret_name
    RefersTo = azurerm_linux_virtual_machine.this.id
  }, local.module_common_tags)
}

# create a Key Vault secret with the public SSH key
resource "azurerm_key_vault_secret" "ssh_public_key" {
  name         = local.ssh_public_key_secret_name
  key_vault_id = data.azurerm_key_vault.shared.id
  value        = replace(tls_private_key.admin.public_key_pem, "/\n/", "\n")
  content_type = "application/x-pem-file"
  tags = merge({
    Name     = local.ssh_public_key_secret_name
    RefersTo = azurerm_linux_virtual_machine.this.id
  }, local.module_common_tags)
}

# since we have purge protection enabled on Key Vault we have make secret names unique with a random suffix
resource "random_uuid" "ssh_key_name_suffix" {
}
