module "diagnostics" {
  source = "../../diagnostics"
  count  = var.diagnostic_profiles == null ? 0 : 1

  global_settings = var.global_settings
  resource_id     = azurerm_hdinsight_kafka_cluster.kafka.id
  diagnostics     = var.diagnostics
  profiles        = var.diagnostic_profiles
}
