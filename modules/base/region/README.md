# Azure Terraform Module: base/region 

Retrieves the information about the given Azure region.

The region information is returned as a Terraform object with the following attributes:

| Attribute Name | Attribute Type | Description                                                                                              |
|----------------|----------------|----------------------------------------------------------------------------------------------------------|
| name           | string         | given name of the Azure region                                                                           |
| id             | string         | unique identifier of the Azure region                                                                    |
| display_name   | string         | human-readable name of the Azure region                                                                  |
| zone_mappings  | list(object)   | availability zone mappings of the Azure region                                                           |
| geo_code       | string         | geo code which can be used to build private DNS names for private endpoints (i.e. `we` for `westeurope`) |
| region_code    | string         | ISO 3166 based region code (i.e. `euw` for `westeurope`)                                                 |                                                 

The zone mapping is returned as a Terraform object with the following attributes:

| Attribute Name      | Attribute Type | Description                                                        |
|---------------------| -------------- |--------------------------------------------------------------------|
| local_zone_id       | string | identifier of the local zone (i.e. `1`)                            |
| physical_zone_id | string | identifier of the associated physical zone (i.e. `westeurope-az2`) |


## Input Variables

see [variables.tf](variables.tf)

## Output Values

see [outputs.tf](outputs.tf)
