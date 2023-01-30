# create a namespace for cert manager
resource kubernetes_namespace cert_manager {
  count = var.addon_enabled ? 1 : 0
  metadata {
    name = var.kubernetes_namespace_name
    labels = { # TODO: consolidate labels!!!
      "istio-injection" = "disabled"
    }
  }
}
