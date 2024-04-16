variable "region_name" {
  description = "The Azure region to deploy into."
  type        = string
}

variable "region_code" {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
  type        = string
}

variable "common_tags" {
  description = "Map of common tags to be attached to all managed Azure resources"
  type        = map(string)
}

variable "solution_name" {
  description = "Name of this Azure solution"
  type        = string
}

variable "solution_stage" {
  description = "Stage of this Azure solution"
  type        = string
}

variable "solution_fqn" {
  description = "Fully qualified name of this Azure solution"
  type        = string
}

variable "resource_group_id" {
  description = "Unique identifier of the resource group supposed to own all allocated resources"
  type        = string
}

variable "aks_cluster_id" {
  description = "Unique identifier of the AKS cluster"
  type        = string
}

variable "kubernetes_cluster_architecture" {
  description = "Processor architecture of the worker nodes of the target AWS EKS cluster; allowed values are: `X86_64` (default), `ARM_64`"
  type        = string
  default     = "X86_64"
  validation {
    condition     = var.kubernetes_cluster_architecture == "X86_64" || var.kubernetes_cluster_architecture == "ARM_64"
    error_message = "The kubernetes_cluster_architecture must be either `X86_64` (Intel-based 64 bit) or `ARM_64` (ARM-based 64 bit)"
  }
}

variable "kubernetes_namespace_name" {
  description = "Name of the Kubernetes namespace supposed to host the ingress controller"
  type        = string
  default     = "ingress-nginx"
}

variable "kubernetes_namespace_owned" {
  description = "Controls if the given Kubernetes namespace will be created and destroyed by this module; default: true"
  type        = bool
  default     = true
}

variable "kubernetes_ingress_class_name" {
  description = "Name of the Kubernetes ingress class to be associated with this ingress controller"
  type        = string
  default     = "nginx"
}

variable "kubernetes_default_ingress_class" {
  description = "Controls if this Kubernetes ingress class is the default ingress class of the cluster"
  type        = bool
  default     = false
}

variable "helm_release_name" {
  description = "Name of the Helm release used to deploy the ingress controller"
  type        = string
  default     = "ingress-nginx"
}

variable "helm_chart_version" {
  description = "Version of the Helm chart used to deploy the ingress controller"
  type        = string
  default     = "4.10.0"
}

variable "replica_count" {
  description = "Number of replicas running NGINX"
  type        = number
  default     = 2
}

variable "ensure_high_availability" {
  description = "Controls if a high availability of this service should be ensured by running at least two pods spread across AZs and nodes"
  type        = bool
  default     = true
}

variable "node_group_workload_class" {
  description = "Class of the AKS node group this tool stack should be hosted on"
  type        = string
  default     = ""
}

variable "cert_manager_enabled" {
  description = "Controls if cert-manager should be used to issue TLS certificates"
  type        = bool
  default     = true
}

variable "cert_manager_issuer_name" {
  description = "Name of a certificate issuer managed by cert-manager"
  type        = string
  default     = ""
}

variable "load_balancer_strategy" {
  description = "Strategy to use when exposing NGINX's endpoints; possible values are `SERVICE_VIA_NODE_PORT`, `SERVICE_VIA_LB` or `INGRESS_VIA_AGW`"
  type        = string
  default     = "INGRESS_VIA_AGW"
}

variable "loadbalancer_id" {
  description = "Unique identifier of an existing load balancer NGiNX is supposed to use; required if `load_balancer_strategy` is either `SERVICE_VIA_LB` or `INGRESS_VIA_AGW`"
  type        = string
  default     = ""
}

variable "public_dns_zone_id" {
  description = "Unique identifier of a public DNS supposed contain all public DNS records to route traffic to this ingress controller"
  type        = string
}

variable "host_names" {
  description = "Host name of requests supposed to be forwarded to the ingress controller; required if `load_balancer_strategy` is `INGRESS_VIA_AGW`"
  type        = list(string)
  default     = []
}

variable "prometheus_operator_enabled" {
  description = "Controls if prometheus operator is installed and pod/service monitors should be enabled"
  type        = bool
  default     = false
}

variable "opentelemetry_enabled" {
  description = "Controls if OpenTelemetry support should be enabled"
  type        = bool
  default     = false
}

variable "opentelemetry_collector_host" {
  description = "Host name of the OpenTelemetry collector endpoint; required if `opentelemetry_enabled` is true"
  type        = string
  default     = ""
}

variable "opentelemetry_collector_port" {
  description = "Port number of the OpenTelemetry collector endpoint; required if `opentelemetry_enabled` is true"
  type        = number
  default     = 0
}
