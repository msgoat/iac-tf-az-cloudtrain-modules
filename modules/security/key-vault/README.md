# security/key-vault

Terraform module which creates an Azure Key Vault instance.

The newly created Key Vault will only accept Azure AD RBAC. By default, the current user / service principal running
this module will become `Key Vault Administrator` of the Azure Key Vault. Additionally, the group IDs of Azure AD
groups can be specified via variable `key_vault_admin_group_ids` whose members are supposed become administrators as well.

## Input Variables

see: [variables.tf](variables.tf)

## Output Values

see: [outputs.tf](outputs.tf)
