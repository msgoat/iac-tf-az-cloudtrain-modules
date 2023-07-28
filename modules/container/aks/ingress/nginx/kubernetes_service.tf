# wait some time until the external loadbalancer IP is hopefully assigned to the ingress controller service
resource time_sleep wait_for_loadbalancer_ip {
  count = var.wait_for_loadbalancer_ip_enabled ? 1 : 0
  depends_on = [helm_release.nginx]
  create_duration = "60s"
}

# retrieve external ip assigned to the nginx ingress controller service
data kubernetes_service_v1 nginx_controller {
  metadata {
    name = "ingress-nginx-controller"
    namespace = var.kubernetes_namespace_name
  }
  depends_on = [time_sleep.wait_for_loadbalancer_ip[0]]
}
