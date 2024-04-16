locals {
  postgres_database_name = "pgdb-${var.region_code}-${var.solution_fqn}-${var.db_database_name}"
}

# create a PostgreSQL database in the newly created PostgreSQL server
resource azurerm_postgresql_database database {
  count = length(var.db_database_name) != 0 ? 1 : 0
  name = var.db_database_name
  resource_group_name = var.resource_group_name
  server_name = azurerm_postgresql_server.postgres.name
  charset = "UTF8"
  collation = "C"
}