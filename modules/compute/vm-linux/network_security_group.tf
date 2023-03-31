locals {
  nsg_name = "nsg-${var.region_code}-${var.solution_fqn}-${var.virtual_machine_name}"
}

resource "azurerm_network_security_group" "this" {
  name                = local.nsg_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = var.region_name
  tags                = merge({ Name = local.nsg_name }, local.module_common_tags)
}

resource "azurerm_network_security_rule" "allow_inbound_ssh_from_vnet_only" {
  name                        = "AllowInboundSshFromVNetOnly"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = data.azurerm_virtual_network.given.address_space
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.given.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_inbound_https_from_anywhere" {
  name                        = "AllowInboundHttpsFromAnywhere"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.given.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_inbound_http_from_anywhere" {
  name                        = "AllowInboundHttpFromAnywhere"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.given.name
  network_security_group_name = azurerm_network_security_group.this.name
}