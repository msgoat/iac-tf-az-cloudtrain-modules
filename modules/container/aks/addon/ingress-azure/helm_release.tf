locals {
  actual_replica_count = var.ensure_high_availability && var.replica_count < 2 ? 2 : var.replica_count
  helm_chart_name      = "ingress-azure"
  helm_chart_values    = <<EOT
verbosityLevel: 3

kubernetes:
  watchNamespace:
  httpServicePort: 8123
  multiClusterMode: false
  nodeSelector: {}
  tolerations: []
  affinity: {}
  securityContext:
    runAsUser: 0
  containerSecurityContext: {}
  podAnnotations: {}
  resources:
    limits:
      cpu: 200m
      memory: 100Mi
    requests:
      cpu: 100m
      memory: 100Mi
  ingressClass: "${var.kubernetes_ingress_class_name}"
  ingressClassResource:
    name: azure-application-gateway
    enabled: true
    default: ${var.kubernetes_default_ingress_class}
    controllerValue: "azure/application-gateway"
appgw:
  environment: AZUREPUBLICCLOUD
  applicationGatewayID: ${data.azurerm_application_gateway.given.id}
armAuth:
  type: workloadIdentity
  identityClientID: ${azurerm_user_assigned_identity.agic.client_id}
rbac:
  enabled: true
EOT
}

# deploys Azure Application Gateway Ingress Controller
resource "helm_release" "ingress_azure" {
  name              = var.helm_release_name
  chart             = local.helm_chart_name
  version           = var.helm_chart_version
  namespace         = var.kubernetes_namespace_owned ? kubernetes_namespace.ingress_azure[0].metadata[0].name : var.kubernetes_namespace_name
  create_namespace  = false
  dependency_update = true
  repository        = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  atomic            = true
  cleanup_on_fail   = true
  values            = [local.helm_chart_values]
}
