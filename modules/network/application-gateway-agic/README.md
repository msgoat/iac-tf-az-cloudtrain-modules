# Azure Terraform Module network/application-gateway-agic

This Terraform module creates an `Azure Application Gateway` in front of an Azure Kubernetes cluster
which will be partially managed by an `Azure Application Gateway Ingress Controller` (AGIC).

## Monitoring

Monitoring can be activated via variable `agw_monitoring_enabled`.

If monitoring is activated, the following logs and metrics will be stored in the given Azure Log Analytics Workspace:

* Access Log
* Performance Log
* Firewall Log
* All metrics

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)

## TODO's
