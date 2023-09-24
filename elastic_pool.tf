resource "azurerm_mssql_elasticpool" "elastic_pool" {
  count = var.asql_sqlserver_create && var.asql_enable_elasticpool ? 1 : 0

  depends_on = [
    azurerm_mssql_server.primary,
  ]

  name                = format("%s-elasticpool", var.asql_sqlserver_name)
  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location
  server_name         = azurerm_mssql_server.primary[0].name
  license_type        = var.asql_elastic_pool_config.license_type
  max_size_gb         = var.asql_elastic_pool_config.max_size_gb
  zone_redundant      = var.asql_elastic_pool_config.zone_redundant

  sku {
    capacity = var.asql_elastic_pool_sku.capacity
    name     = var.asql_elastic_pool_sku.name
    tier     = var.asql_elastic_pool_sku.tier
    family   = var.asql_elastic_pool_sku.family
  }

  per_database_settings {
    max_capacity = coalesce(var.asql_elastic_pool_per_database_settings.max_capacity, var.asql_elastic_pool_sku.capacity)
    min_capacity = var.asql_elastic_pool_per_database_settings.min_capacity
  }

  lifecycle {
    ignore_changes = [
      license_type,
      tags,
    ]
  }
}