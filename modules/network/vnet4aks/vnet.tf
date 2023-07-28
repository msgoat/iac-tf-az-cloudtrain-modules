module vnet {
  source = "../vnet"
  region_name = var.region_name
  region_code = var.region_code
  solution_fqn = var.solution_fqn
  solution_name = var.solution_name
  solution_stage = var.solution_stage
  common_tags = var.common_tags
  resource_group_id = var.resource_group_id
  network_name = var.network_name
  network_cidr = var.network_cidr
  subnet_templates = [
    {
      name = "systempool"
      accessibility = "private"
      role = "SystemPoolContainer"
      newbits = 4
    },
    {
      name = "userpool"
      accessibility = "private"
      role = "UserPoolContainer"
      newbits = 4
    },
    {
      name = "endpoints"
      accessibility = "private"
      role = "PrivateEndpointContainer"
      newbits = 4
    },
    {
      name = "resources"
      accessibility = "private"
      role = "ResourceContainer"
      newbits = 4
    },
    {
      name = "web"
      accessibility = "public"
      role = "InternetFacingContainer"
      newbits = 8
    }
  ]
}