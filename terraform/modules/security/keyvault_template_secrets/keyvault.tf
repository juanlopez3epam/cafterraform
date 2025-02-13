resource "azurerm_key_vault_secret" "secret" {
  name         = var.settings.secret_name
  value        = coalesce(local.multi_line_template_result, local.single_line_template_result)
  key_vault_id = var.keyvault.id
}
