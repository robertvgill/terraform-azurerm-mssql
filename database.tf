resource "azurerm_mssql_database" "db" {
  for_each = var.asql_sqlserver_create ? toset(var.asql_databases) : []

  depends_on = [
    azurerm_mssql_server.primary,
  ]

  name                        = format("%s", each.key)
  server_id                   = azurerm_mssql_server.primary[0].id
  auto_pause_delay_in_minutes = var.asql_database_config.sku_name != "ElasticPool" ? var.asql_database_config.auto_pause_delay_in_minutes : null
  max_size_gb                 = var.asql_database_config.max_size_gb
  min_capacity                = var.asql_database_config.min_capacity
  sku_name                    = var.asql_database_config.sku_name
  elastic_pool_id             = var.asql_database_config.sku_name == "ElasticPool" ? azurerm_mssql_elasticpool.elastic_pool[0].id : null
  geo_backup_enabled          = var.asql_database_config.geo_backup_enabled
  storage_account_type        = var.asql_database_config.storage_account_type
  zone_redundant              = var.asql_database_config.zone_redundant
  tags                        = merge({ "ResourceName" = format("%s", each.key) }, var.tags, )

  dynamic "threat_detection_policy" {
    for_each = var.asql_threat_policy_config.state == true ? [1] : []

    content {
      state                      = var.asql_threat_policy_config.state
      disabled_alerts            = var.asql_threat_policy_config.disabled_alerts
      email_account_admins       = var.asql_threat_policy_config.email_account_admins
      email_addresses            = var.asql_threat_policy_config.email_addresses
      retention_days             = var.asql_threat_policy_config.retention_days
      storage_account_access_key = data.azurerm_storage_account.asqldz.primary_access_key
      storage_endpoint           = data.azurerm_storage_account.asqldz.primary_blob_endpoint
    }
  }

  lifecycle {
    ignore_changes = [
      geo_backup_enabled,
      tags,
    ]
  }
}
/**
resource "azurerm_mssql_database" "secondary" {
  for_each        = var.asql_sqlserver_create ? toset(var.asql_databases) : []

  depends_on = [
    azurerm_mssql_server.secondary,
  ]

  name                        = format("%s-database-secondary", each.key)
  server_id                   = azurerm_mssql_server.secondary[0].id
  create_mode                 = "Secondary"
  creation_source_database_id = azurerm_mssql_database.primary[each.key].id
  auto_pause_delay_in_minutes = var.asql_database_config.auto_pause_delay_in_minutes
  max_size_gb                 = var.asql_database_config.max_size_gb
  min_capacity                = var.asql_database_config.min_capacity
  sku_name                    = var.asql_database_config.sku_name
  zone_redundant              = var.asql_database_config.zone_redundant
  tags                        = merge({ "ResourceName" = format("%s", each.key) }, var.tags, )
}
**/