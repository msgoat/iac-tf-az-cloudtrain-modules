locals {
  sqlserver_server_name = "sql-${var.region_code}-${var.solution_fqn}-${var.db_instance_name}"
  # make sure that random user name does not start with a digit
  admin_user_name = length(regexall("^[[:digit:]]", random_string.admin_user.result)) > 0 ? "sql${random_string.admin_user.result}" : random_string.admin_user.result
}

# create an Azure SQLServer server instance using Single Server deployment mode
resource azurerm_mssql_server server {
  name = local.sqlserver_server_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  version = var.sqlserver_version
  administrator_login = local.admin_user_name
  administrator_login_password = random_password.admin_user.result
  minimum_tls_version = "1.2"
  public_network_access_enabled = var.public_access_enabled
  tags = merge({
    Name = local.sqlserver_server_name
  }, local.module_common_tags)
}