locals {
  agw_name_suffix                       = var.application_gateway_name != "" ? "-${var.application_gateway_name}" : ""
  agw_name                              = "agw-${var.region_code}-${var.solution_fqn}${local.agw_name_suffix}"
  backend_address_pool_name             = "defaultaddresspool"
  backend_http_settings_name            = "defaulthttpsetting"
  gateway_ip_configuration_name         = "appGatewayIpConfig"
  public_frontend_ip_configuration_name = "appGwPublicFrontendIp"
  public_frontend_http_port_name        = "port_80"
  public_frontend_https_port_name       = "port_443"
  public_http_listener_name             = "PublicHttpListener"
  public_https_listener_name            = "PublicHttpsListener"
  public_ssl_certificate_name           = "PublicHttpsCertificate"
  probe_name                            = "defaultprobe-Http"
  public_request_routing_rule_name      = "RoutePublicHttpsTrafficToIngress"
  host_names                            = [data.azurerm_dns_zone.given.name, "*.${data.azurerm_dns_zone.given.name}"]
}

resource "azurerm_application_gateway" "gateway" {
  name                = local.agw_name
  resource_group_name = data.azurerm_resource_group.given.name
  location            = data.azurerm_resource_group.given.location
  enable_http2        = true
  zones               = var.names_of_zones_to_span
  tags                = merge({ Name = local.agw_name }, local.module_common_tags)

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 32000
    protocol              = "Http"
  }

  frontend_ip_configuration {
    name                 = local.public_frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.gateway.id
    # subnet_id            = data.azurerm_subnet.given.id
  }

  frontend_port {
    name = local.public_frontend_http_port_name
    port = 80
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = data.azurerm_subnet.given.id
  }

  http_listener {
    name                           = local.public_http_listener_name
    frontend_ip_configuration_name = local.public_frontend_ip_configuration_name
    frontend_port_name             = local.public_frontend_http_port_name
    protocol                       = "Http"
    host_names                     = local.host_names
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.gateway.id]
  }

  request_routing_rule {
    name                       = "ForwardToDummyBackend"
    http_listener_name         = local.public_http_listener_name
    rule_type                  = "Basic"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
    priority                   = 100
  }

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  global {
    request_buffering_enabled  = false
    response_buffering_enabled = false
  }

  lifecycle {
    // Ignore almost all changes since the existing application gateway will be controlled by the AGIC ingress controller
    ignore_changes = [backend_address_pool, backend_http_settings, frontend_port, http_listener, request_routing_rule, probe, tags, ssl_certificate]
  }
}
