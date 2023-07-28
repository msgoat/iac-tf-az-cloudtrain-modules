locals {
  zone_numbers = range(1, var.zones_to_span + 1)
  zone_names = [for z in local.zone_numbers : tostring(z) ]
}