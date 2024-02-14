# Terraform Module: aks/addon/application-gateway-ingress 

Installs the [Azure Application Gateway Ingress Controller](https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview) addon on a given AKS cluster.

> __Note__: This is the Helm-based installation mode of the Application Gateway Ingress Controller!

## Prerequisites

* Requires `Entra Workload Identity` add-on to be enabled on the given AKS cluster

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)

## TODO's
