module "keyvaults" {
  source   = "../../modules/security/keyvault"
  for_each = local.keyvaults

  global_settings     = var.global_settings
  client_config       = local.client_config
  settings            = each.value
  resource_groups     = local.consolidated_objects_resource_groups
  managed_identities  = local.consolidated_objects_managed_identities
  diagnostic_profiles = each.value.diagnostic_profiles
  diagnostics         = local.diagnostics
  subnets             = local.consolidated_objects_subnets
  dns_zones           = local.consolidated_objects_private_dns_zones
}

module "keyvault_access_policies" {
  source   = "../../modules/security/keyvault_access_policies"
  for_each = local.keyvault_access_policies

  keyvault_key    = each.key
  keyvaults       = local.consolidated_objects_keyvaults
  access_policies = each.value
  client_config   = local.client_config
  resources = {
    managed_identities = local.consolidated_objects_managed_identities
    storage_accounts   = local.consolidated_objects_storage_accounts
    app_registrations  = local.consolidated_objects_app_registrations
  }
}

module "keyvault_secrets" {
  depends_on = [module.keyvaults, module.keyvault_access_policies]

  source   = "../../modules/security/keyvault_secret"
  for_each = local.keyvault_secrets

  settings = each.value
  keyvault = local.consolidated_objects_keyvaults[local.client_config.landingzone_key][each.value.keyvault_key]
}

module "keyvault_keys" {
  depends_on = [module.keyvaults, module.keyvault_access_policies]

  source = "../../modules/security/keyvault_key"

  for_each = local.keyvault_keys

  global_settings = var.global_settings
  settings        = each.value
  keyvault        = local.consolidated_objects_keyvaults[local.client_config.landingzone_key][each.value.keyvault_key]
}

module "dynamic_keyvault_secrets" {
  depends_on = [module.keyvaults, module.keyvault_access_policies]

  source = "../../modules/security/keyvault_dynamic_secrets"

  for_each = local.dynamic_keyvault_secrets

  global_settings = var.global_settings
  settings        = each.value
  keyvault        = local.consolidated_objects_keyvaults[local.client_config.landingzone_key][each.value.keyvault_key]
}

module "dynamic_keyvault_object_secrets" {
  depends_on = [module.keyvaults, module.keyvault_access_policies]

  source = "../../modules/security/keyvault_object_secrets"

  for_each      = local.dynamic_object_secrets
  settings      = each.value
  keyvault      = local.consolidated_objects_keyvaults[local.client_config.landingzone_key][each.value.keyvault_key]
  client_config = local.client_config
  resources = {
    app_registrations = local.consolidated_objects_app_registrations
  }
}

