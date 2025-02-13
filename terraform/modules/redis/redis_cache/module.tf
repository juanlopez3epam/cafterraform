resource "azurecaf_name" "redis" {
  name          = var.redis.name
  resource_type = "azurerm_redis_cache"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis" {
  name                = azurecaf_name.redis.result
  location            = var.global_settings.regions[coalesce(var.redis.region, var.global_settings.default_region)]
  resource_group_name = var.resource_group_name
  capacity            = var.redis.capacity
  family              = var.redis.family
  sku_name            = var.redis.sku_name
  tags                = local.tags

  enable_non_ssl_port           = var.redis.enable_non_ssl_port
  minimum_tls_version           = var.redis.minimum_tls_version
  private_static_ip_address     = var.redis.private_static_ip_address
  public_network_access_enabled = var.redis.public_network_access_enabled
  replicas_per_master           = var.redis.replicas_per_master
  replicas_per_primary          = var.redis.replicas_per_primary
  redis_version                 = var.redis.redis_version
  shard_count                   = var.redis.shard_count
  zones                         = var.redis.zones
  subnet_id                     = try(var.subnet_id, null)

  dynamic "redis_configuration" {
    for_each = try(var.redis.redis_configuration[*], [])

    content {
      enable_authentication           = lookup(redis_configuration.value, "enable_authentication", null)
      maxmemory_reserved              = lookup(redis_configuration.value, "maxmemory_reserved", null)
      maxmemory_delta                 = lookup(redis_configuration.value, "maxmemory_delta", null)
      maxmemory_policy                = lookup(redis_configuration.value, "maxmemory_policy", null)
      maxfragmentationmemory_reserved = lookup(redis_configuration.value, "maxfragmentationmemory_reserved", null)
      rdb_backup_enabled              = lookup(redis_configuration.value, "rdb_backup_enabled", null)
      rdb_backup_frequency            = lookup(redis_configuration.value, "rdb_backup_frequency", null)
      rdb_backup_max_snapshot_count   = lookup(redis_configuration.value, "rdb_backup_max_snapshot_count", null)
      rdb_storage_connection_string   = lookup(redis_configuration.value, "rdb_storage_connection_string", null)
      notify_keyspace_events          = lookup(redis_configuration.value, "notify_keyspace_events", null)
    }
  }
  dynamic "patch_schedule" {
    for_each = try(var.redis.patch_schedule[*], [])

    content {
      day_of_week    = patch_schedule.value.day_of_week
      start_hour_utc = lookup(patch_schedule.value, "start_hour_utc", null)
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
