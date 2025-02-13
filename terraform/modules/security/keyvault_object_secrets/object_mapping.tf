

module "app_registrations" {
  source       = "./object_secret"
  count        = var.settings.app_registration_key != "" ? 1 : 0
  name         = try(var.resources.app_registrations[var.client_config.landingzone_key][var.settings.app_registration_key].application_id, null)
  value        = try(var.resources.app_registrations[var.client_config.landingzone_key][var.settings.app_registration_key].application_client_secret, null)
  key_vault_id = var.keyvault.id
  settings     = var.settings
}