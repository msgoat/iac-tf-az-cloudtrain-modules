# create a random username for the PostgreSQL admin user
resource random_string db_user {
  length = 16
  special = false
}

# create a random password for the PostgreSQL admin user
# since Key Vault does not like have secrets with special characters, we simply do not use them
resource random_password db_password {
  length = 25
  special = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}