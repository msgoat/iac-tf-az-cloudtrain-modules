# create a random username for the SQLServer admin user
resource random_string admin_user {
  length = 16
  special = false
}

# create a random password for the SQLServer admin user
# since Key Vault does not like have secrets with special characters, we simply do not use them
resource random_password admin_user {
  length = 128
  special = true
  override_special = "!$#%"
}