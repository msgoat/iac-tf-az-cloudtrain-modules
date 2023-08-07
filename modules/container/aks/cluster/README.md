# Terraform Module container/aks/cluster 

Creates an Azure AKS instance with a secure baseline setup as recommended by Microsoft
(except the hub-spoke network topology).

## Input Variables

see [variables.tf](variables.tf)

Node pools like system pools and user pools are specified using node pool templates:

| Template attribute | Type         | Mandatory | Description |
| --- |--------------|-----------| --- |
| enabled | bool         | x         | controls if this node pool should be created |
| name | string       | x         | name of this node pool template will be transformed into a fully qualified node pool name |
| role | string       | x         | role of the node pool; must be either "user" or "system" |
| vm_sku | string       | x         | Azure VM instance type to be used for the pool |
| max_size | number       | x         | maximum number of nodes in this pool |
| min_size | number       | x         | minimum number of nodes in this pool |
| desired_size | number       |           | desired number of nodes in this pool; default: min_size |
| max_surge | string       |           | number of nodes or percentage of nodes supposed to be created on pool scaling or pool updates; default: "33%" |
| kubernetes_version | string       |           | kubernetes version of all nodes; default: kubernetes version of cluster |
| os_disk_size | number       | x         |  boot disk size of nodes in GB |
| subnet_id | string |  | unique ID of the subnet supposed to host this pool; default: user_pool_subnet_id or system_pool_subnet_id depending on pool role |
| labels | map(string) | x         | optional kubernetes labels to be assigned to all nodes of this pool |
| taints | list(string) |  | optional kubernetes taints to be assigned to all nodes of this pool |

## Output Values

see [outputs.tf](outputs.tf)

## TODO's

* install AGIC via Helm chart since adding roles to AGIC managed identity of addon is quite cumbersome
