# Terraform Module database/elasticsearch/kubernetes 

Installs `Elasticsearch` on the given AKS cluster using the 
[official Elasticsearch helm chart](https://github.com/elastic/helm-charts/blob/master/elasticsearch/Chart.yaml).

> Unfortunately, Elasticsearch's basic license requires both username/password AND TLS encryption on TLS endpoints.
> Since we still have to clarify how to establish TLS connections within the cluster, all Elasticsearch endpoints
> are completely unprotected for now !!!

> Due to the fact that Elasticsearch security cannot be activated (see above), Elasticsearch will only be accessible from 
> within the AKS cluster !!! Use port forwarding if you need to access Elasticsearch from outside the AKS cluster.

## Input Variables 

see [variables.tf](variables.tf)

## Output Values 

see [outputs.tf](outputs.tf)

## TODO

| TODO | Description | Status |
| --- | --- | --- |
| Activate TLS | In order to activate Elasticsearch security with username/password we need TLS certificates as well | OPEN | 

