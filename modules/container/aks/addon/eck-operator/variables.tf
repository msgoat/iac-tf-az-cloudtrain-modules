variable "region_name" {
  description = "The Azure region to deploy into."
  type        = string
}

variable region_code {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
  type = string
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

variable "common_tags" {
  description = "Map of common tags to be attached to all managed Azure resources"
  type        = map(string)
}

variable "aks_cluster_id" {
  description = "Unique identifier of the target Azure AKS cluster"
  type        = string
}

variable "kubernetes_namespace_name" {
  description = "Name of the Kubernetes namespace supposed to host the Elastic Cloud Operator for Kubernetes"
  type        = string
  default     = "elastic"
}

variable "kubernetes_namespace_owned" {
  description = "Controls if the given Kubernetes namespace will be created and destroyed by this module; default: true"
  type        = bool
  default     = true
}

variable "helm_chart_version" {
  description = "Version of the Helm chart to use to deploy the Elastic Cloud Operator for Kubernetes"
  type        = string
  default     = "2.9.0"
}

variable "helm_release_name" {
  description = "Name of the Helm release used to deploy the Elastic Cloud Operator for Kubernetes"
  type        = string
  default     = "eckop"
}

variable "replica_count" {
  description = "Number of replicas running Elastic Cloud Operator for Kubernetes"
  type        = number
  default     = 2
}

variable "node_group_workload_class" {
  description = "Class of the EKS node group the Elastic Cloud Operator for Kubernetes should be hosted on"
  type        = string
  default     = ""
}

variable "ensure_high_availability" {
  description = "Controls if a high availability of this service should be ensured by running at least two pods spread across AZs and nodes"
  type        = bool
  default     = true
}

variable "cert_manager_enabled" {
  description = "Controls if cert-manager is installed and should be used for certificate management"
  type        = bool
  default     = false
}

variable "prometheus_operator_enabled" {
  description = "Controls if Prometheus is installed as an operator"
  type        = bool
  default     = false
}