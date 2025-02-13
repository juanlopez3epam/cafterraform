module "diagnostics" {
  source = "../../diagnostics"
  count  = try(var.settings.diagnostic_profiles, null) == null ? 0 : 1

  global_settings = var.global_settings
  resource_id     = azurerm_network_security_group.nsg.id
  diagnostics     = var.diagnostics
  profiles        = var.settings.diagnostic_profiles
}
