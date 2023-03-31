locals {
  subnet_template_values = [for i, snt in var.subnet_templates : {
    subnet_key           = snt.name
    subnet_name          = "snet-${var.region_code}-${var.solution_fqn}-${var.network_name}-${snt.name}"
    subnet_template_name = snt.name
    accessibility        = snt.accessibility
    role                 = snt.role
    cidr                 = cidrsubnet(var.network_cidr, snt.newbits, i + 1)
    tags                 = snt.tags
  }]
  subnet_template_keys    = [for snt in var.subnet_templates : snt.name]
  subnet_templates_by_key = zipmap(local.subnet_template_keys, local.subnet_template_values)
}

# create the subnets based on the given templates
resource "azurerm_subnet" "subnets" {
  for_each             = local.subnet_templates_by_key
  name                 = each.value.subnet_name
  resource_group_name  = data.azurerm_resource_group.given.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.cidr]
}

locals {
  subnets = [for snt in local.subnet_template_values : {
    subnet_id            = azurerm_subnet.subnets[snt.subnet_key].id
    subnet_name          = snt.subnet_name
    subnet_template_name = snt.subnet_template_name
    accessibility        = snt.accessibility
    role                 = snt.role
  }]
}


