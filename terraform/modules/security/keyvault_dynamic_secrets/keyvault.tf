resource "random_password" "value" {
  length           = var.settings.config.length
  upper            = var.settings.config.upper
  numeric          = var.settings.config.numeric
  special          = var.settings.config.special
  min_lower        = var.settings.config.min_lower
  min_numeric      = var.settings.config.min_numeric
  min_special      = var.settings.config.min_special
  min_upper        = var.settings.config.min_upper
  override_special = var.settings.config.override_special
}

resource "azurerm_key_vault_secret" "secret" {
  name         = var.settings.secret_name
  value        = random_password.value.result
  key_vault_id = var.keyvault.id
  tags         = local.tags
}
