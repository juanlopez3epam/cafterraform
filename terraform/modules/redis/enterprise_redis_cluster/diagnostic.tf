module "diagnostics" {
  source = "../../diagnostics"
  count  = var.diagnostic_profiles == null ? 0 : 1

  global_settings = var.global_settings
  resource_id     = azurerm_redis_enterprise_cluster.redis.id
  diagnostics     = var.diagnostics
  profiles        = var.diagnostic_profiles
}
