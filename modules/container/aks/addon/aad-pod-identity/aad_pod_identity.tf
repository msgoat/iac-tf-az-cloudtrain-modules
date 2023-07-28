# deploys Azure AD Pod Identity controller on AKS cluster
resource helm_release aad_pod_identity {
  count = var.addon_enabled ? 1 : 0
  name = "aad-pod-identity"
  chart = "aad-pod-identity"
  version = "4.1.6"
  namespace = module.namespace.k8s_namespace_name
  create_namespace = false
  dependency_update = true
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  atomic = true
  cleanup_on_fail = true
  values = [ file("${path.module}/resources/helm/aad-pod-identity/values.yaml") ]
}
