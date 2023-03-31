locals {
  admin_user_name      = "az${random_string.admin.result}"
  virtual_machine_name = "vm-${var.region_code}-${var.solution_fqn}-${var.virtual_machine_name}"
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = local.virtual_machine_name
  resource_group_name             = data.azurerm_resource_group.given.name
  location                        = var.region_name
  size                            = var.virtual_machine_size
  admin_username                  = local.admin_user_name
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.this.id
  ]
  # custom_data = base64encode(templatefile("${path.module}/resources/vm-custom-data.template.sh", {}))
  tags = merge({
    "Name" = local.virtual_machine_name
  }, local.module_common_tags)

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = 50
  }

  admin_ssh_key {
    username   = local.admin_user_name
    public_key = tls_private_key.admin.public_key_openssh
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }
}
