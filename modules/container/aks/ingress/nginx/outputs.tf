output aks_ingress_controller_ip {
  description = "IP address of the ingress controller"
  value = data.kubernetes_service_v1.nginx_controller.status[0].load_balancer[0].ingress[0].ip
}

output aks_ingress_controller_type {
  description = "Type of ingress controller installed"
  value = "nginx"
}

output aks_ingress_controller_protocol {
  description = "Protocol for inbound traffic to the ingress controller"
  value = "http"
}

output aks_ingress_controller_port {
  description = "Port number for inbound traffic to the ingress controller"
  value = 80
}

output aks_ingress_controller_probe_protocol {
  description = "Protocol used to probe the ingress controllers health"
  value = "http"
}

output aks_ingress_controller_probe_port {
  description = "Port number used to probe the ingress controllers health"
  value = 80
}

output aks_ingress_controller_probe_path {
  description = "URI path used to probe the ingress controllers health"
  value = "/healthz"
}

output aks_ingress_controller_probe_status_codes {
  description = "Expected HTTP status codes for health checks on the AKS ingress controller"
  value = [200, 404]
}

