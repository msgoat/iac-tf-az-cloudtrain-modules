variable region_name {
  description = "The Azure region to deploy into."
  type = string
}

variable region_code {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
  type = string
}

variable common_tags {
  description = "Map of common tags to be attached to all managed Azure resources"
  type = map(string)
}

variable solution_name {
  description = "Name of this Azure solution"
  type = string
}

variable solution_stage {
  description = "Stage of this Azure solution"
  type = string
}

variable solution_fqn {
  description = "Fully qualified name of this Azure solution"
  type = string
}

variable resource_group_name {
  description = "The name of the resource group supposed to own all allocated resources"
  type = string
}

variable resource_group_location {
  description = "The location of the resource group supposed to own all allocated resources"
  type = string
}

variable aks_cluster_id {
  description = "Unique identifier of the AKS cluster"
  type = string
}

variable kubernetes_namespace_name {
  description = "Name of the Kubernetes namespace supposed to host the ingress controller"
  type = string
  default = "ingress-nginx"
}

variable helm_release_name {
  description = "Name of the Helm release used to deploy the ingress controller"
  type = string
  default = "ingress-nginx"
}

variable wait_for_loadbalancer_ip_enabled {
  description = "Controls if the module should wait until a loadbalancer IP has been assigned to the ingress controller service"
  type = bool
  default = true
}

variable loadbalancer_ip_wait_seconds {
  description = "Seconds to wait until a loadbalancer IP has been assigned to the ingress controller service"
  type = string
  default = "60s"
}

variable node_group_workload_class {
  description = "Class of the AKS node group this tool stack should be hosted on"
  type = string
  default = ""
}

variable opentracing_config {
  description = "Optional configuration of OpenTracing support; specifying this variable implies that OpenTracing support is enabled"
  type = object({
    jaeger_agent_host = string
    jaeger_agent_port = number
  })
  default = null
}

variable aks_addon_agic_enabled {
  description = "Enables the Azure Application Gateway Ingress Controller"
  type = bool
  default = false  # @TODO: remove default
}

variable aks_addon_agic_ingress_host_name {
  description = "Host name the AGIC ingress of NGinX should listen to"
  type        = string
  default     = "cxp.k8s.azure.msgoat.eu" # @TODO: remove default
}

