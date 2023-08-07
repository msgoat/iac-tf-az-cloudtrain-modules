# Azure Terraform Module: network/vnet4aks 

Manages the VNet supposed to host an AKS Kubernetes cluster.

This module creates an opinionated set of subsets with the following roles:
* `SystemPoolContainer`: subnet with about __4096__ available private IP addresses hosting all system pools of the AKS cluster
* `UserPoolContainer`: subnet with about __4096__ available private IP addresses hosting all user pools of the AKS cluster
* `PrivateEndpointContainer`: subnet with about __4096__ available private IP addresses hosting all private endpoints used by the AKS cluster
* `ResourceContainer`: subnet with about __4096__ available private IP addresses hosting all private resources like databases etc. used by the AKS cluster
* `InternetFacingContainer`: subnet with about __255__ available private IP addresses hosting all internet facing resources like application gateways etc in front of the AKS cluster
* `InternalLoadBalancerContainer`: subnet with about __255__ available private IP addresses hosting all private load balancers in front of the AKS cluster

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)
