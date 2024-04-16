output "dns_zone_id" {
  description = "Unique identifier of the newly created public DNS zone"
  value       = azurerm_dns_zone.this.id
}
