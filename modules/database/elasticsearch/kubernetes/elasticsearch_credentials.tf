locals {
  es_default_user = "elastic"
}

# create a random password for the Elasticsearch user
# since Key Vault does not like have secrets with special characters, we simply do not use them
resource random_password password {
  length = 25
  special = false
}