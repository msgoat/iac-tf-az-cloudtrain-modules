# variables.tf
# ---------------------------------------------------------------------------
# Defines all input variable for this demo.
# ---------------------------------------------------------------------------

variable region_name {
  description = "The Azure region to deploy into."
  type = string
}

variable region_code {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
  type = string
}

variable solution_name {
  description = "The name of the Azure solution that owns all Azure resources."
  type = string
}

variable solution_stage {
  description = "The name of the current Azure solution stage."
  type = string
}

variable solution_fqn {
  description = "The fully qualified name of the current Azure solution."
  type = string
}

variable common_tags {
  description = "Common tags to be attached to all Azure resources"
  type = map(string)
}

variable aks_cluster_id {
  description = "Unique identifier of an Azure AKS cluster"
  type = string
}

variable kubernetes_namespace_name {
  description = "Name of the Kubernetes namespace to deploy to"
  type = string
  default = "monitoring"
}

variable "kubernetes_namespace_owned" {
  description = "Controls if the given Kubernetes namespace will be created and destroyed by this module; default: true"
  type = bool
  default = true
}

variable kubernetes_ingress_class_name {
  description = "Name of the ingress class to be used to expose Grafana UI and Prometheus UI"
  type = string
}

variable kubernetes_ingress_controller_type {
  description = "Type of the ingress controller to be used to expose Grafana UI and Prometheus UI; possible values are: `NGINX` or `TRAEFIK`"
  type = string
}

variable kubernetes_storage_class_name {
  description = "Name of the storage class to be used for all persistence volume claims"
  type = string
}

variable helm_release_name {
  description = "Name of the Helm release which represents a deployment of this stack"
  type = string
  default = "monitoring"
}

variable helm_chart_version {
  description = "Version of the upstream Helm chart"
  type = string
  default = "57.1.0"
}

variable prometheus_storage_size {
  description = "Size of Prometheus Server's persistent volume claim in GB; default `8`"
  type = number
  default = 8
}

variable prometheus_ui_enabled {
  description = "Controls if the Prometheus UI should be exposed; default: false"
  type = bool
  default = false
}

variable prometheus_host_name {
  description = "Fully qualified host name to be used to route traffic to the Prometheus UI; only required if prometheus_ui_enabled is true"
  type = string
  default = ""
}

variable prometheus_path {
  description = "Path to be used to route traffic to the Prometheus UI; only required if prometheus_ui_enabled is true"
  type = string
  default = ""
}

variable alert_manager_enabled {
  description = "Controls if the Prometheus Alert Manager should be deployed as well; default: false"
  type = bool
  default = false
}

variable alert_manager_storage_size {
  description = "Size of Prometheus Alert Manager's persistent volume claim in GB; default `8`"
  type = number
  default = 8
}

variable alert_manager_ui_enabled {
  description = "Controls if the Prometheus Alert Manager UI should be exposed; default: false"
  type = bool
  default = false
}

variable alert_manager_host_name {
  description = "Fully qualified host name to be used to route traffic to the Prometheus Alert Manager UI; only required if alertmanager_ui_enabled is true"
  type = string
  default = ""
}

variable alert_manager_path {
  description = "Path to be used to route traffic to the Prometheus Alert Manager UI; only required if alertmanager_ui_enabled is true"
  type = string
  default = ""
}

variable grafana_ui_enabled {
  description = "Controls if the Grafana UI should be exposed; default: true"
  type = bool
  default = true
}

variable grafana_storage_size {
  description = "Size of Grafana's persistent volume claim in GB; default `8`"
  type = number
  default = 8
}

variable grafana_host_name {
  description = "Fully qualified host name to be used to route traffic to the Grafana UI"
  type = string
}

variable grafana_path {
  description = "Path to be used to route traffic to the Grafana UI"
  type = string
}

variable replica_count {
  description = "Number of replicas for all pods; default `2`"
  type = number
  default = 2
}

variable retention_days {
  description = "Number of days the telemetry data should be retained; default `7`"
  type = number
  default = 7
}

variable cert_manager_enabled {
  description = "Controls if all certificates required for this solution are provided via cert-manager; default: false"
  type = bool
  default = false
}

variable cert_manager_cluster_issuer_name {
  description = "Name of the ClusterIssuer used to issue certificates; required if `cert_manager_enabled` is true"
  type = string
  default = ""
}

variable "ensure_high_availability" {
  description = "Controls if a high availability of this service should be ensured by running at least two pods spread across AZs and nodes"
  type = bool
  default = true
}

variable "node_group_workload_class" {
  description = "Workload class which refers to a specific node group this addon should be hosted on; default unspecified (i.e. workload is running on default node group)"
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "Unique identifier the common key vault instance used by this solution."
  type        = string
}

