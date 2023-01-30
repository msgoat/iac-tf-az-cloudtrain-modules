# Terraform Module: container/kubernetes/addon/aad-pod-identity 

This Terraform module installs the `Azure AD Pod Identity Addon` on a given AKS cluster.

@see: [Azure/aad-pod-identity GitHub Repository](https://github.com/Azure/aad-pod-identity)

## Prerequisites

* The target AKS cluster must use the Azure CNI network plugin.
* The AKS managed identity for kubelet must have sufficient roles to apply Azure AD identities to running pods (see documentation above).

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)
