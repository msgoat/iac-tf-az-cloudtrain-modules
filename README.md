# Terraform modules library iac-tf-az-cloudtrain-modules

Set of Terraform modules to manage cloud infrastructure on Microsoft Azure.

Originally developed for msg's `Cloud Training Program` and `Cloud Expert Program`.

> Still work in progress! Provided AS IS without any warranties!

## Module Versioning

This terraform multi-module is versioning via git tags. The main revision number according to semantic versioning
is stored in file [revision.txt](revision.txt). During the build further parts like branch name and short commit hash
are added to the tag name as well.

So if revision is `1.1.1` and the branch is `main` and the short commit hash is `12345678` the git tag name is `1.1.1.main.12345678`.

Whenever you want to pin the module version used in your terraform live code to a specific version
like `1.1.1.main.12345678`, add the corresponding tag name to the modules `source` attribute:

```text
module "eks_cluster" {
    source = "git::https://github.com/msgoat/iac-tf-az-cloudtrain-modules.git//modules/terraform/remote-state?ref=1.1.1.main.12345678"
}
```

## Release Information

A changelog can be found in [changelog.md](changelog.md).

## Status

![Build status](https://codebuild.eu-west-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiK2VWRThzb0J1bkNlMFBhM0FLL0ZoUDlGa0ZRSUxFdmMrYTRlNm5vUklWTUE5c0V4TlJWcEFyUHE4TkVZcmk5SXg2WjB2SDZybUJNdjNmOGdhanBmTlFvPSIsIml2UGFyYW1ldGVyU3BlYyI6InlRUm9BdXZoaGtJSnUxU2kiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)

## Provided Terraform modules

| Module Name                                                        | Module Source                            | Description                                                                           |
|--------------------------------------------------------------------|------------------------------------------|---------------------------------------------------------------------------------------|
| [base/region](modules/base/region/README.md)            | /modules/base/readme | Returns information about a given Azure region. |
| [container/aks/cluster](modules/container/aks/cluster/README.md)   | /modules/container/aks/cluster           | Creates a naked AKS Kubernetes cluster.                                               |
| [network/vnet](modules/network/vnet/README.md)                     | /modules/network/vnet                    | Creates a generic VNets with subnets based on the given subnet templates.             |
| [network/vnet4aks](modules/network/vnet4aks/README.md)             | /modules/network/vnet4aks                | Creates an opinionated VNet to host an AKS Kubernetes cluster.                        |
| [security/key-vault](modules/security/key-vault/README.md)         | /modules/security/key-vault              | Creates an Azure Key Vault instance.                                                  |
| [terraform/remote-state](modules/terraform/remote-state/README.md) | /modules/terraform/remote-state          | Creates a backend for Terraform remote state on Azure.                                |

## TODOs

| TODO | Description | Status |
| ---- | ----------- | ---- |
| Remove provider definitions | In order to follow best practices all provider definitions (NOT provider version constraints) need to be removed from module code | NEW |