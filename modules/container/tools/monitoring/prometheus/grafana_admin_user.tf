# create a random username for the Grafana admin user
resource random_string admin {
  length = 16
  special = false
}

# create a random password for the Grafana admin user
# since Key Vault does not like have secrets with special characters, we simply do not use them
resource random_password admin {
  length = 25
  special = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}