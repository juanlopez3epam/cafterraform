resource "azurecaf_name" "mssqldb" {
  name          = var.settings.name
  resource_type = "azurerm_mssql_database"
  prefixes      = try(coalesce(try(var.settings.naming_convention.prefixes, null), var.global_settings.prefixes), null)
  suffixes      = try(coalesce(try(var.settings.naming_convention.suffixes, null), var.global_settings.suffixes), null)
  random_length = try(coalesce(try(var.settings.naming_convention.random_length, null), var.global_settings.random_length), null)
  clean_input   = true
  separator     = try(coalesce(try(var.settings.naming_convention.separator, null), var.global_settings.separator), null)
  passthrough   = try(coalesce(try(var.settings.naming_convention.passthrough, null), var.global_settings.passthrough), null)
  use_slug      = try(coalesce(try(var.settings.naming_convention.use_slug, null), var.global_settings.use_slug), null)
}

resource "azurerm_mssql_database" "mssqldb" {
  auto_pause_delay_in_minutes = var.settings.auto_pause_delay_in_minutes
  collation                   = var.settings.collation
  create_mode                 = var.settings.create_mode
  creation_source_database_id = var.settings.creation_source_database_id
  elastic_pool_id             = var.elastic_pool_id
  geo_backup_enabled          = var.settings.geo_backup_enabled
  license_type                = var.settings.license_type
  max_size_gb                 = var.settings.max_size_gb
  min_capacity                = var.settings.min_capacity
  name                        = azurecaf_name.mssqldb.result
  read_replica_count          = var.settings.read_replica_count
  read_scale                  = var.settings.read_scale
  recover_database_id         = var.settings.recover_database_id
  restore_dropped_database_id = var.settings.restore_dropped_database_id
  restore_point_in_time       = var.settings.restore_point_in_time
  sample_name                 = var.settings.sample_name
  server_id                   = var.server.id
  sku_name                    = var.settings.sku_name
  storage_account_type        = var.settings.storage_account_type
  zone_redundant              = var.settings.zone_redundant

  dynamic "short_term_retention_policy" {
    for_each = can(var.settings.short_term_retention_policy) ? [var.settings.short_term_retention_policy] : []

    content {
      retention_days = var.settings.short_term_retention_policy.retention_days
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = can(var.settings.long_term_retention_policy) ? [var.settings.long_term_retention_policy] : []

    content {
      weekly_retention  = var.settings.long_term_retention_policy.weekly_retention
      monthly_retention = var.settings.long_term_retention_policy.monthly_retention
      yearly_retention  = var.settings.long_term_retention_policy.yearly_retention
      week_of_year      = var.settings.long_term_retention_policy.week_of_year
    }
  }
}
