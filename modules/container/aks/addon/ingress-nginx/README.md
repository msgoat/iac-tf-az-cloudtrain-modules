# Terraform Module container/aks/ingress/nginx 

Installs `NGinX` as a Kubernetes ingress controller to a given AKS cluster.

Unfortunately, the default backend of the NGinX ingress controller does not work on ARM-based nodes. 
Thus, the default backend is disabled by default.

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)
