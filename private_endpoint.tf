resource "azurerm_private_endpoint" "asqlpep-primary" {
  count               = var.asql_sqlserver_create && var.asql_enable_private_endpoint ? 1 : 0

  depends_on = [
    azurerm_mssql_server.primary,
  ]

  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location

  name                = format("%s-private-endpoint", azurerm_mssql_server.primary[0].name)
  subnet_id           = data.azurerm_subnet.sql[0].id

  private_service_connection {
    name                           = format("%s-private-endpoint", var.asql_sqlserver_name)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.primary[0].id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = format("%s", azurerm_mssql_server.primary[0].name)
    private_dns_zone_ids = [azurerm_private_dns_zone.asqldz[0].id]
  }

  tags     = merge({ "ResourceName" = format("%s-private-endpoint", azurerm_mssql_server.primary[0].name) }, var.tags, )
}
/**
resource "azurerm_private_endpoint" "asqlpep-secondary" {
  count               = var.asql_sqlserver_create ? 1 : 0

  depends_on = [
    azurerm_mssql_server.primary,
  ]

  resource_group_name = azurerm_resource_group.secondary[0].name
  location            = azurerm_resource_group.secondary[0].location

  name                = format("%s-private-endpoint", azurerm_mssql_server.secondary[0].name)
  subnet_id           = data.azurerm_subnet.sql[0].id

  private_service_connection {
    name                           = format("%s-private-endpoint", azurerm_mssql_server.secondary[0].name)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.secondary[0].id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = format("%s", var.asql_private_dns_zone_name)
    private_dns_zone_ids = [azurerm_private_dns_zone.asqldz[0].id]
  }

  tags     = merge({ "ResourceName" = format("%s-private-endpoint", azurerm_mssql_server.secondary[0].name) }, var.tags, )
}
**/