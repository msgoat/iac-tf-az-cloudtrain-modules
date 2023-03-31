# Terraform modules library iac-tf-az-cloudtrain-modules

Set of Terraform modules to manage cloud infrastructure on Microsoft Azure.

Originally developed for msg's `Cloud Training Program` and `Cloud Expert Program`.

> Still work in progress! Provided AS IS without any warranties!

## Provided Terraform modules

| Module Name                                                                 | Module Source                                     | Description                                                                |
|-----------------------------------------------------------------------------|---------------------------------------------------|----------------------------------------------------------------------------|
| [network/vnet](modules/network/vnet/README.md)                              | /modules/network/vnet                             | Creates a single Linux virtual machine.                                    |
| [security/key-vault](modules/security/key-vault/README.md)                  | /modules/security/key-vault                       | Creates an Azure Key Vault instance.                                       |
| [terraform/remote-state](modules/terraform/remote-state/README.md) | /modules/terraform/remote-state | Creates a backend for Terraform remote state on Azure. |

## TODOs

| TODO | Description | Status |
| ---- | ----------- | ---- |
| Remove provider definitions | In order to follow best practices all provider definitions (NOT provider version constraints) need to be removed from module code | NEW |