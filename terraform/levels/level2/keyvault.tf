module "keyvaults" {
  source             = "../../modules/security/keyvault"
  for_each           = local.keyvaults
  global_settings    = var.global_settings
  settings           = each.value
  resource_groups    = local.consolidated_objects_resource_groups
  client_config      = local.client_config
  managed_identities = module.managed_identities
}

module "keyvault_access_policies" {
  source          = "../../modules/security/keyvault_access_policies"
  for_each        = local.keyvault_access_policies
  keyvault_key    = each.key
  keyvaults       = module.keyvaults
  client_config   = local.client_config
  access_policies = each.value
  resources = {
    managed_identities = module.managed_identities
  }
}

module "keyvault_secrets" {
  depends_on = [module.keyvaults, module.keyvault_access_policies]
  source     = "../../modules/security/keyvault_secret"
  for_each   = var.keyvault_secrets
  settings   = each.value
  keyvault   = module.keyvaults[each.value.keyvault_key]
}

module "keyvault_keys" {
  depends_on      = [module.keyvaults, module.keyvault_access_policies]
  source          = "../../modules/security/keyvault_key"
  for_each        = var.keyvault_keys
  global_settings = var.global_settings
  settings        = each.value
  keyvault        = module.keyvaults[each.value.keyvault_key]
}
