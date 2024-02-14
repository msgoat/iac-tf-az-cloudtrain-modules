locals {
  actual_replica_count = var.ensure_high_availability && var.replica_count < 2 ? 2 : var.replica_count
  helm_chart_name = "ingress-azure"
  helm_chart_values = <<EOT
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
  resources: {}
    #limits:
    #  cpu: 200m
    #  memory: 100Mi
    #requests:
    #  cpu: 100m
    #  memory: 100Mi
  ingressClass: "azure/application-gateway"
  ingressClassResource:
    name: azure-application-gateway
    enabled: true
    default: false
    controllerValue: "azure/application-gateway"

################################################################################
# Specify which application gateway the ingress controller will manage
# Specity which cloud environment will be used AZURECHINACLOUD,AZUREGERMANCLOUD,AZUREPUBLICCLOUD,AZUREUSGOVERNMENTCLOUD default: AZUREPUBLICCLOUD
#
appgw:
  environment: AZUREPUBLICCLOUD
  subscriptionId: ${local.agw_subscription_id}
  resourceGroup: ${local.agw_rg_name}
  name: ${local.agw_name}
#   # Whether to force private IP for all the listeners on Application Gateway
#   usePrivateIP: false
#   subResourceNamePrefix: "myPrefix"

################################################################################
# Specify the authentication with Azure Resource Manager
armAuth:
  type: workloadIdentity
  identityClientID: ${azurerm_user_assigned_identity.agic.client_id}

################################################################################
# (Legacy: use `kubernetes.nodeSelector` instead) Specify the scheduling options
nodeSelector: {}

################################################################################
# Specify if the cluster is RBAC enabled or not
rbac:
  enabled: true
EOT
}

# deploys ExternalDNS
resource helm_release ingress_azure {
  name = var.helm_release_name
  chart = local.helm_chart_name
  version = var.helm_chart_version
  namespace = var.kubernetes_namespace_owned ? kubernetes_namespace.ingress_azure[0].metadata[0].name : var.kubernetes_namespace_name
  create_namespace = false
  dependency_update = true
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  atomic = true
  cleanup_on_fail = true
  values = [ local.helm_chart_values ]
}
