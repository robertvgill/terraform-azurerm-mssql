## key vault
data "azurerm_key_vault" "akv" {
  count               = var.asql_sqlserver_create ? 1 : 0

  name                = format("%s", var.akv_key_vault_name)
  resource_group_name = var.rg_resource_group_name
}

data "azurerm_key_vault_secret" "admin_username" {
  count               = var.akv_key_vault_name != null ? 1 : 0

  name                = format("%s", var.asql_key_vault_secret_admin_username)
  key_vault_id        = data.azurerm_key_vault.akv[0].id
}

data "azurerm_key_vault_secret" "admin_password" {
  count               = var.akv_key_vault_name != null ? 1 : 0

  name                = format("%s", var.asql_key_vault_secret_admin_password)
  key_vault_id        = data.azurerm_key_vault.akv[0].id
}

## vnet
data "azurerm_virtual_network" "vnet" {
  count               = var.asql_sqlserver_create ? 1 : 0

  name                = format("%s", var.nw_virtual_network_name)
  resource_group_name = var.rg_resource_group_name
}

## subnet
data "azurerm_subnet" "sql" {
  count      = var.asql_sqlserver_create ? 1 : 0

  name                 = format("%s", var.nw_vnet_subnet_sql)
  virtual_network_name = var.nw_virtual_network_name
  resource_group_name  = var.rg_resource_group_name
}

## private dns
data "azurerm_private_dns_zone" "asqldz" {
  count               = var.asql_sqlserver_create && var.asql_does_private_dns_zone_exist ? 1 : 0

  name                = format("%s", lower(var.asql_private_dns_zone_name))
  resource_group_name = var.rg_resource_group_name
}

## storage account
data "azurerm_storage_account" "asqlsa" {
  count      = var.asql_sqlserver_create ? 1 : 0
  name                = var.st_storage_account_name
  resource_group_name = var.rg_resource_group_name
}