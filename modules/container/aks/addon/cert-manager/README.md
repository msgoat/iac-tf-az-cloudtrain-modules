# Terraform Module: aks/addon/cert-manager 

Installs the `Kubernetes cert-manager` addon on a given AKS cluster.

By default, two cluster certificate issuers will be added to the given AKS cluster:
* `letsencrypt-prod` generates TLS certificates from Let's Encrypts production environment
* `letsencrypt-staging` generates TLS certificates from Let's Encrypts staging environment

Since Lets Encrypts production environment has a certificate request quota, the `letsencrypt-staging` issuer should
be used for all testing purposes. After you made sure, that the certificate issuing process works, you are safe to 
switch to the `letsencrypt-prod` issuer.

@see: [Kubernetes cert-manager](https://cert-manager.io/docs/)

## Prerequisites

* The Entra Workload Identity add-on must be enabled on the given AKS cluster.

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)

## TODO's
