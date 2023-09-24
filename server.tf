## azure sql
resource "azurerm_mssql_server" "primary" {
  count                                = var.asql_sqlserver_create ? 1 : 0

  name                                 = var.asql_secondary_create ? format("%s-primary", var.asql_sqlserver_name) : format("%s", var.asql_sqlserver_name)
  resource_group_name                  = var.rg_resource_group_name
  location                             = var.rg_location
  version                              = var.asql_sqlserver_config.version
  administrator_login                  = data.azurerm_key_vault_secret.admin_username[0].value
  administrator_login_password         = data.azurerm_key_vault_secret.admin_password[0].value
  connection_policy                    = var.asql_sqlserver_config.connection_policy
  minimum_tls_version                  = var.asql_sqlserver_config.minimum_tls_version
  public_network_access_enabled        = var.asql_sqlserver_config.public_network_access_enabled
  outbound_network_restriction_enabled = var.asql_sqlserver_config.outbound_network_restriction_enabled
  tags                                 = merge({ "ResourceName" = var.asql_secondary_create ? format("%s-primary", var.asql_sqlserver_name) : format("%s", var.asql_sqlserver_name) }, var.tags, )

  dynamic "identity" {
    for_each = var.asql_identity == true ? [1] : [0]
    content {
      type = "SystemAssigned"
    }
  }
}

resource "azurerm_mssql_server" "secondary" {
  count                                = var.asql_sqlserver_create && var.asql_secondary_create ? 1 : 0

  name                                 = format("%s-secondary", var.asql_sqlserver_name)
  resource_group_name                  = azurerm_resource_group.secondary[0].name
  location                             = azurerm_resource_group.secondary[0].location
  version                              = var.asql_sqlserver_config.version
  administrator_login                  = data.azurerm_key_vault_secret.admin_username[0].value
  administrator_login_password         = data.azurerm_key_vault_secret.admin_password[0].value
  connection_policy                    = var.asql_sqlserver_config.connection_policy
  minimum_tls_version                  = var.asql_sqlserver_config.minimum_tls_version
  public_network_access_enabled        = var.asql_sqlserver_config.public_network_access_enabled
  outbound_network_restriction_enabled = var.asql_sqlserver_config.outbound_network_restriction_enabled
  tags                                 = merge({ "ResourceName" = var.asql_secondary_create ? format("%s-secondary", var.asql_sqlserver_name) : format("%s", var.asql_sqlserver_name) }, var.tags, )

  dynamic "identity" {
    for_each = var.asql_identity == true ? [1] : [0]
    content {
      type = "SystemAssigned"
    }
  }
}