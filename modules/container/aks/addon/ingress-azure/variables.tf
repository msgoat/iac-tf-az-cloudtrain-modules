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

variable "kubernetes_namespace_name" {
  description = "Name of the Kubernetes namespace supposed to host the Application Gateway Ingress Controller"
  type        = string
  default     = "ingress-azure"
}

variable "kubernetes_namespace_owned" {
  description = "Controls if the given Kubernetes namespace will be created and destroyed by this module; default: true"
  type        = bool
  default     = true
}

variable "kubernetes_ingress_class_name" {
  description = "Name of the Kubernetes ingress class to be assigned to this ingress controller"
  type        = string
  default     = "azure/application-gateway"
}

variable "kubernetes_default_ingress_class" {
  description = "Controls if this ingress controller is the default ingress controller on this cluster; default: false"
  type        = bool
  default     = false
}

variable "helm_release_name" {
  description = "Name of the Helm release used to deploy the Application Gateway Ingress Controller"
  type        = string
  default     = "ingress-azure"
}

variable "helm_chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "1.7.4"
}

variable "replica_count" {
  description = "Number of replicas to run"
  type        = number
  default     = 2
}

variable "dns_zone_id" {
  description = "Unique identifier of a public DNS supposed contain all public DNS records to route traffic to the Kubernetes cluster"
  type        = string
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

variable "application_gateway_id" {
  description = "Unique identifier of the application gateway supposed to route traffic to the Kubernetes cluster"
  type        = string
}