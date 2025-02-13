module "diagnostics" {
  source = "../../diagnostics"
  count  = var.diagnostic_profiles == null ? 0 : 1

  global_settings = var.global_settings
  resource_id     = azurerm_kubernetes_cluster.k8s.id
  diagnostics     = var.diagnostics
  profiles        = var.diagnostic_profiles
}
