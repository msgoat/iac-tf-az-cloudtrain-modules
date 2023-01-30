# Azure Terraform Module: database/redis/redis-cache

Creates an `Azure Cache for Redis` server.
Username and password of the Redis admin user will be determined by the Azure Cache for Redis service and
propagates as access keys and connection strings.
Optionally drops a private endpoint to a given subnet hosting private endpoints to Azure services.
Optionally creates a Kubernetes secret with access keys and connection strings in all given Kubernetes namespaces 
to be consumed by applications running in those namespaces.

## Default Redis server configuration

* Default instance configuration
  * Server instance SKU `Standard_C0`
* Public network access is disabled
* TLS endpoints only 

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)

## TODOs

| TODO | Description | Status |
| --- | --- | --- |
| Clarify contents of Kubernetes secret | Concrete properties of a Kubernetes secret referring to Redis must be specified. | OPEN |
