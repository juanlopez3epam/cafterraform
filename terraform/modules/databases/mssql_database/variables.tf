variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = {}
}
variable "settings" {
  description = "(Required) Used to handle passthrough parameters."
  type = object({
    name                        = string
    auto_pause_delay_in_minutes = optional(number, null)
    collation                   = optional(string, null)
    create_mode                 = optional(string, null)
    creation_source_database_id = optional(string, null)
    elastic_pool_id             = optional(string, null)
    geo_backup_enabled          = optional(bool, false)
    license_type                = optional(string, null)
    max_size_gb                 = optional(number, null)
    min_capacity                = optional(number, null)
    read_replica_count          = optional(number, null)
    read_scale                  = optional(bool, false)
    recover_database_id         = optional(string, null)
    restore_dropped_database_id = optional(string, null)
    restore_point_in_time       = optional(string, null)
    sample_name                 = optional(string, null)
    sku_name                    = optional(string, null)
    sku_tier                    = optional(string, null)
    storage_account_type        = optional(string, null)
    zone_redundant              = optional(bool, false)
    naming_convention = optional(object({
      prefixes      = optional(list(string), null)
      suffixes      = optional(list(string), null)
      random_length = optional(number, null)
      passthrough   = optional(bool, false)
      separator     = optional(string, null)
      use_slug      = optional(bool, true)
    }), null)
  })
}
variable "server" {
  description = "The SQL Server object"
  type        = any
}
variable "elastic_pool_id" {
  description = "(Optional) The ID of the Elastic Pool in which to create the database."
  type        = string
  default     = null
}
variable "diagnostics" {
  description = "Diagnostics object"
  type = object({
    diagnostics_definition   = optional(any, null)
    diagnostics_destinations = optional(any, null)
    log_analytics_workspaces = optional(any, null)
    eventhub_name            = optional(any, null)
    eventhub_authorization_rule_id = optional(any, null)
  })
  default = null
}
variable "diagnostic_profiles" {
  description = "Diagnostics profiles"
  type = map(object({
    definition_key   = string
    destination_type = string
    destination_key  = string
  }))
  default = null
}
