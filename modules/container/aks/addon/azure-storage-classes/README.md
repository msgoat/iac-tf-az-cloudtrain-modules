# Terraform Module: container/kubernetes/addon/azure-storage-classes

Adds Azure specific Kubernetes storage classes to the given AKS cluster which provide Kubernetes persistent volumes
using server-side encryption with customer-managed keys (CMK).

Uses the Azure Disk Encryption Set attached to the given AKS cluster to encrypt the dynamically provisioned persitent volumes.

The following storage classes are added:

| Storage Class Name  | Description                                   |
|---------------------|-----------------------------------------------|
| cmk-csi-standard    | Standard SSD disks with CMK backed encryption |
| cmk-csi-premium     | Premium disks with CMK backed encryption      | 




