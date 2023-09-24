## resource group
variable "rg_resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
  default     = null
}

variable "rg_location" {
  description = "Specifies the supported Azure location where the resource should be created."
  type        = string
  default     = null
}

## key vault
variable "akv_key_vault_name" {
  description = "The name of the Azure Key Vault for PostgreSQL."
  type        = string
}

## virtual network
variable "nw_virtual_network_name" {
  description = "The name of the Virtual Network."
  type        = string
  default     = null
}

variable "nw_vnet_subnet_aks" {
  description = "The name of the subnet for AKS."
  type        = string
}

variable "nw_vnet_subnet_sql" {
  description = "The name of the subnet for Azure SQL."
  type        = string
}

## storage account
variable "st_storage_account_name" {
  description = "The name of the Azure storage account"
  type        = string
  default     = null
}

## azure sql
variable "asql_sqlserver_create" {
  description = "Controls if Azure SQL should be created."
  type        = bool
  default     = false
}

variable "asql_sqlserver_name" {
  description = "The name of the Azure SQL."
  type        = string
  default     = null
}

variable "asql_key_vault_secret" {
  description = "The name of the secret associated with the administrator login."
  default     = null  
}

variable "asql_identity" {
  description = "If you want your SQL Server to have an managed identity. Defaults to false."
  default     = false
}

variable "asql_key_vault_secret_admin_username" {
  description = "The name of the secret associated with the administrator login."
  default     = null  
}

variable "asql_key_vault_secret_admin_password" {
  description = "The name of the secret associated with the administrator password."
  default     = null  
}

variable "asql_sqlserver_config" {
  description = "Azure SQL server configuration."
  type = object({
    version                              = string
    connection_policy                    = string
    minimum_tls_version                  = string
    public_network_access_enabled        = bool
    outbound_network_restriction_enabled = bool
  })
  default = null
}

variable "asql_database_create" {
  description = "Controls if Azure database(s) should be created."
  type        = bool
  default     = false
}

variable "asql_databases" {
  description = "For each SQL database, create an object that contain fields."
  type        = list(string)
  default     = []
}

variable "asql_database_config" {
  description = "Azure SQL server configuration."
  type = object({
    auto_pause_delay_in_minutes = number
    geo_backup_enabled          = bool
    max_size_gb                 = number
    min_capacity                = number
    sku_name                    = string
    storage_account_type        = string
    zone_redundant              = bool
  })
  default = null
}

variable "asql_threat_policy_config" {
  description = "Threat Policy configuration for Azure SQL."
  type = object({
    state                = string
    disabled_alerts      = bool
    email_account_admins = list(string)
    email_addresses      = list(string)
    retention_days       = number
  })
  default = null
}

variable "asql_private_dns_zone_name" {
  description = "The name of the Private DNS zone for Azure SQL."
  default     = null
}

variable "asql_does_private_dns_zone_exist" {
  type        = bool
  default     = false
}

variable "asql_enable_private_endpoint" {
  description = "Manages a Private Endpoint to Azure SQL."
  default     = false
}

variable "asql_secondary_create" {
  description = "Controls if secondary Azure SQL server should be created."
  type        = bool
  default     = false
}

variable "asql_secondary_resource_group" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
  default     = null
}

variable "asql_secondary_location" {
  description = "Specifies the supported Azure location where the resource should be created."
  type        = string
  default     = null
}

variable "asql_enable_elasticpool" {
  description = "Deploy the databases in an ElasticPool if enabled. Otherwise, deploy single databases."
  type        = bool
  default     = true
}

variable "asql_elastic_pool_config" {
  description = "Elastic Pool configuration for Azure SQL."
  type = object({
    license_type   = string
    max_size_gb    = number
    zone_redundant = bool
  })
  default = null
}

variable "asql_elastic_pool_sku" {
  description = "Elastic Pool SKU for Azure SQL."
  type = object({
    capacity = number
    name     = string
    tier     = string
    family   = string
  })
  default = null
}

variable "asql_elastic_pool_per_database_settings" {
  description = "Elastic Pool per database settings for Azure SQL."
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
}