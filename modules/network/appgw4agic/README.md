# Azure Terraform Module network/appgw4agic

This Terraform module creates an `Azure Application Gateway` in front of an Azure Kubernetes cluster
which will be partially managed by an `Azure Application Gateway Ingress Controller` (AGIC).

## TLS certificates for HTTPS endpoints

There are two ways to provide TLS certificates for HTTPS endpoints:
1. either provide a name of an existing TLS certificate managed by Azure Key Vault (variable `agw_key_vault_certificate_name` is set)
2. or let the module auto-generate TLS certificates via Azure Key Vault for all given host names (variable `agw_key_vault_certificate_name` is not set)

## Public DNS records

For each given non-wildcard host name passed via variable `agw_host_names`, 
a new public DNS record will be added to the given public DNS zone.

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
