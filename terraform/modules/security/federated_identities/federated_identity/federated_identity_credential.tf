resource "azurecaf_name" "federated_identity_credential" {
  name          = var.settings.name
  resource_type = "azurerm_federated_identity_credential"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}
resource "azurerm_federated_identity_credential" "federated_identity_credential" {
  name                = azurecaf_name.federated_identity_credential.result
  resource_group_name = var.resource_group_name
  parent_id           = var.parent_id
  audience            = var.settings.audience
  issuer              = var.issuer
  subject             = var.settings.subject
}
