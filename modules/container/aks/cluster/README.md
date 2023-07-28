# Terraform Module container/kubernetes/cluster 

Creates an Azure AKS instance with a secure baseline setup as recommended by Microsoft
(except the hub-spoke network topology).

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)

## TODO's

* install AGIC via Helm chart since adding roles to AGIC managed identity of addon is quite cumbersome
