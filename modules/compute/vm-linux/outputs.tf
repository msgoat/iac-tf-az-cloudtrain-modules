output "vm_id" {
  description = "Unique identifier of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.id
}

output "vm_fqn" {
  description = "Fully qualified name of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.name
}

output "vm_admin_user_name" {
  description = "Name of the admin user to connect to the virtual machine"
  value       = azurerm_linux_virtual_machine.this.admin_username
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine, if `public_access_enabled` is set"
  value       = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}