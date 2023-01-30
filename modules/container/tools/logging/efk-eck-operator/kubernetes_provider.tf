provider kubernetes {
    host                   = local.aks_host
    username               = local.aks_username
    password               = local.aks_password
    client_certificate     = local.aks_client_certificate
    client_key             = local.aks_client_key
    cluster_ca_certificate = local.aks_cluster_ca_certificate
}
