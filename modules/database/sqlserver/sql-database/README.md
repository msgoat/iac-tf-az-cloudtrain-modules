# Azure Terraform Module: database/SQLServer/single-server

Creates an `Azure Database for SQLServer` server using a random username and a random password for the SQLServer admin
user. Username and password of the SQLServer admin user will be stored as a Key Vault secret in the given Key Vault.
Optionally drops a private endpoint to a given subnet hosting private endpoints to Azure services. Optionally creates a
Kubernetes secret with username and password of the SQLServer admin user in all given Kubernetes namespaces to be
consumed by applications running in those namespaces.

> Currently, only `Single Server` deployment mode is supported!

## Default SQLServer server configuration

* Default instance configuration
    * Server instance SKU `GP_Gen5_2`: 2 Core 8GB RAM (private endpoints not supported on `Basic` servers)
    * Default minimum storage size: 20 GB
    * Autogrow on storage enabled
* Public network access is enabled
* Customer managed keys (CMK) to encrypt data at rest are supported but cannot be enabled (see: TODOs)

## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)

## TODOs

| TODO | Description | Status |
| --- | --- | --- |
| Add data encryption with CMK | Unfortunately, provisioning a SQLServer server with data encryption using a CMK fails when using Terraform. But we need this to meet the security baseline for SQLServer servers. | OPEN |
| Support more deployment modes | Currently, SQLServer is available in different deployment modes. Unfortunately, the most appropriate deployment mode `Flexible Server` is still in preview state. | OPEN |