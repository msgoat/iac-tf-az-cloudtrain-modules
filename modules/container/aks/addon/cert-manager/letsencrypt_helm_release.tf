locals {
  letencrypt_values = <<EOT
fullnameOverride: letsencrypt
letsencrypt:
  acme:
    email: ${var.letsencrypt_account_name}
    dnsZones:
      - ${local.public_dns_zone_name}
    azureDns:
      resourceGroupName: ${local.public_dns_zone_rg_name}
      subscriptionId: ${local.public_dns_zone_subscription_id}
      hostedZoneName: ${local.public_dns_zone_name}
      managedIdentityClientId: ${azurerm_user_assigned_identity.cert_manager.client_id}
EOT
}

resource "helm_release" "letsencrypt" {
  chart             = "${path.module}/resources/helm/cert-manager-letsencrypt"
  name              = "letsencrypt"
  dependency_update = true
  atomic            = true
  cleanup_on_fail   = true
  namespace = var.kubernetes_namespace_owned ? kubernetes_namespace.cert_manager[0].metadata[0].name : var.kubernetes_namespace_name
  create_namespace  = false
  values            = [ local.letencrypt_values ]
  depends_on = [helm_release.cert_manager]
}