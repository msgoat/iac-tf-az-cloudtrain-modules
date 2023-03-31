locals {
  network_interface_name = "nic-${var.region_code}-${var.solution_fqn}-${var.virtual_machine_name}"
}

resource "azurerm_network_interface" "this" {
  name                = local.network_interface_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = var.region_name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_access_enabled ? azurerm_public_ip.this[0].id : null
    subnet_id                     = var.subnet_id
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}