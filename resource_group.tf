resource "azurerm_resource_group" "secondary" {
  count     = var.asql_sqlserver_create && var.asql_secondary_create ? 1 : 0

  name     = format("%s", var.asql_secondary_resource_group)
  location = var.asql_secondary_location

  lifecycle {
    prevent_destroy = false
  }

  tags     = merge({ "Resource Name" = format("%s", var.asql_secondary_resource_group) }, var.tags, )
}