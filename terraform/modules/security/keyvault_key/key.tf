resource "azurerm_key_vault_key" "key" {
  name            = var.settings.name
  key_vault_id    = var.keyvault.id
  key_type        = var.settings.key_type
  key_opts        = var.settings.key_opts
  key_size        = var.settings.key_size
  curve           = var.settings.curve
  not_before_date = var.settings.not_before_date
  expiration_date = var.settings.expiration_date
  tags            = local.tags
}
