locals {
  agw_name_suffix = var.application_gateway_name != "" ? "-${var.application_gateway_name}" : ""
  agw_name = "agw-${var.region_code}-${var.solution_fqn}${local.agw_name_suffix}"
  backend_address_pool_name = "defaultaddresspool"
  backend_http_settings_name = "defaulthttpsetting"
  gateway_ip_configuration_name = "appGatewayIpConfig"
  public_frontend_ip_configuration_name = "appGwPublicFrontendIp"
  public_frontend_http_port_name = "port_80"
  public_frontend_https_port_name = "port_443"
  public_http_listener_name = "PublicHttpListener"
  public_https_listener_name = "PublicHttpsListener"
  public_ssl_certificate_name = "PublicHttpsCertificate"
  probe_name = "defaultprobe-Http"
  public_request_routing_rule_name = "RoutePublicHttpsTrafficToIngress"
}

resource azurerm_application_gateway gateway {
  name = local.agw_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  tags = merge({Name = local.agw_name}, local.module_common_tags)

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port = 32000
    protocol = "Http"
  }

  frontend_ip_configuration {
    name = local.public_frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw_external.id
  }

  frontend_port {
    name = local.public_frontend_http_port_name
    port = 80
  }

  frontend_port {
    name = local.public_frontend_https_port_name
    port = 443
  }

  gateway_ip_configuration {
    name = local.gateway_ip_configuration_name
    subnet_id = var.agw_subnet_id
  }

  http_listener {
    name = local.public_http_listener_name
    frontend_ip_configuration_name = local.public_frontend_ip_configuration_name
    frontend_port_name = local.public_frontend_http_port_name
    protocol = "Http"
    host_names = var.agw_host_names
  }

  http_listener {
    name = local.public_https_listener_name
    frontend_ip_configuration_name = local.public_frontend_ip_configuration_name
    frontend_port_name = local.public_frontend_https_port_name
    protocol = "Https"
    ssl_certificate_name = local.public_ssl_certificate_name
    host_names = var.agw_host_names
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.agw.id]
  }

  request_routing_rule {
    name = "ForwardToKubernetes"
    http_listener_name = local.public_https_listener_name
    rule_type = "Basic"
    backend_address_pool_name = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
    priority = 100
  }

  request_routing_rule {
    name = "RedirectHttpToHttps"
    http_listener_name = local.public_http_listener_name
    rule_type = "Basic"
    redirect_configuration_name = "RedirectHttpToHttps"
    priority = 200
  }

  redirect_configuration {
    name                 = "RedirectHttpToHttps"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = local.public_https_listener_name
  }

  ssl_certificate {
    name = local.public_ssl_certificate_name
    key_vault_secret_id = length(var.agw_key_vault_certificate_name) != 0 ? data.azurerm_key_vault_certificate.given[0].secret_id : azurerm_key_vault_certificate.generated[0].secret_id
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = var.agw_min_capacity
    max_capacity = var.agw_max_capacity
  }
}
