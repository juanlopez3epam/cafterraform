variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "redis" {
  description = "Redis Cache settings object (see module README.md)"
  type = object({
    name     = string
    region   = optional(string, null)
    sku_name = string
    capacity = number
    family   = string
    tags     = optional(map(any), null)

    enable_non_ssl_port           = optional(bool, null)
    minimum_tls_version           = optional(string, null)
    private_static_ip_address     = optional(string, null)
    public_network_access_enabled = optional(bool, null)
    replicas_per_master           = optional(number, null)
    replicas_per_primary          = optional(number, null)
    redis_version                 = optional(string, "6.2")
    shard_count                   = optional(number, null)
    zones                         = optional(list(string), null)

    redis_configuration = optional(object({
      enable_authentication           = optional(bool, null)
      maxmemory_delta                 = optional(number, null)
      maxmemory_reserved              = optional(number, null)
      maxmemory_policy                = optional(string, null)
      maxfragmentationmemory_reserved = optional(number, null)
      rdb_backup_enabled              = optional(bool, null)
      rdb_backup_frequency            = optional(number, null)
      rdb_backup_max_snapshot_count   = optional(number, null)
      notify_keyspace_events          = optional(string, null)
    }), null)
    patch_schedule = optional(any, null)
  })
}
variable "resource_group_name" {
  description = "Resource group name"
  type        = any
}
variable "tags" {
  description = "(optional) Map of tags to be applied to the resource"
  type        = map(any)
  default     = null
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}
variable "subnet_id" {
  description = "Subnet ID"
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
