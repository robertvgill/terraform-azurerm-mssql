resource "azurerm_mssql_failover_group" "failover" {
  count     = var.asql_sqlserver_create && var.asql_secondary_create ? 1 : 0

  name      = format("%s-failover-group", var.asql_sqlserver_name)
  server_id = azurerm_mssql_server.primary[0].id
  databases = values(azurerm_mssql_database.db)[*].id

  partner_server {
    id = azurerm_mssql_server.secondary[0].id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }

  depends_on = [
    azurerm_mssql_server.secondary
  ]
}