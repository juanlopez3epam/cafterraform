resource "azurerm_key_vault_secret" "secret" {
  name            = var.name
  value           = var.value
  key_vault_id    = var.key_vault_id
  content_type    = var.settings.content_type
  not_before_date = var.settings.not_before_date
  expiration_date = var.settings.expiration_date
  tags            = var.settings.tags
}