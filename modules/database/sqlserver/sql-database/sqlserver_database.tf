locals {
  sqlserver_database_name = "sqldb-${var.region_code}-${var.solution_fqn}-${var.db_database_name}"
}

# create a SQLServer database in the newly created SQLServer server
resource azurerm_mssql_database database {
  name = var.db_database_name
  server_id = azurerm_mssql_server.server.id
  collation = "SQL_Latin1_General_CP1_CS_AS"
  max_size_gb = var.db_max_storage_size
  min_capacity = 0.5
  auto_pause_delay_in_minutes = 60
  sku_name = "GP_S_Gen5_1"
  zone_redundant = false
  tags = merge({
    Name = var.db_database_name
  }, local.module_common_tags)
}