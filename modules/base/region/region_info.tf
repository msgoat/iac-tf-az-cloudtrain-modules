data "azurerm_location" "this" {
  location = var.region_name
}

locals {
  zone_mappings = [for zm in data.azurerm_location.this.zone_mappings : {
    local_zone_id    = zm.logical_zone
    physical_zone_id = zm.physical_zone
  }]
  region_info = {
    name = var.region_name
    id   = data.azurerm_location.this.id
    # type = data.azurerm_location.this.region_type
    display_name  = data.azurerm_location.this.display_name
    zone_mappings = local.zone_mappings
    geo_code      = local.geo_codes_by_region_name[var.region_name]
    region_code   = local.region_codes_by_region_name[var.region_name]
  }
}