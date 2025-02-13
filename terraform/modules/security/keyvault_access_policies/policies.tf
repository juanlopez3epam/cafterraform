module "azuread_apps" {
  source = "./access_policy"
  for_each = {
    for key, access_policy in var.access_policies : key => access_policy
    if try(access_policy.azuread_app_key, null) != null
  }

  keyvault_id = coalesce(
    var.keyvault_id,
    try(var.keyvaults[each.value.keyvault_lz_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.client_config.landingzone_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.keyvault_key].id, null),
  )

  access_policy = each.value
  tenant_id     = var.client_config.tenant_id
  object_id = coalesce(
    try(var.azuread_apps[each.value.lz_key][each.value.azuread_app_key].azuread_service_principal.object_id, null),
    try(var.azuread_apps[each.value.azuread_app_lz_key][each.value.azuread_app_key].azuread_service_principal.object_id, null),
    try(var.azuread_apps[var.client_config.landingzone_key][each.value.azuread_app_key].azuread_service_principal.object_id, null),
    try(var.azuread_apps[each.value.azuread_app_key].azuread_service_principal.object_id, null),
  )
}

module "azuread_group" {
  source = "./access_policy"
  for_each = {
    for key, access_policy in var.access_policies : key => access_policy
    if try(access_policy.azuread_group_key, null) != null
  }

  keyvault_id = coalesce(
    var.keyvault_id,
    try(var.keyvaults[each.value.keyvault_lz_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.client_config.landingzone_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.keyvault_key].id, null),
  )

  access_policy = each.value
  tenant_id     = var.client_config.tenant_id
  object_id = coalesce(
    try(var.azuread_groups[each.value.lz_key][each.value.azuread_group_key].id, null),
    try(var.azuread_groups[each.value.azuread_group_key].id, null),
  )
}

module "app_registrations" {
  source = "./access_policy"
  for_each = {
    for key, access_policy in var.access_policies : key => access_policy
    if access_policy.enterprise_application_key != null
  }

  keyvault_id = coalesce(
    var.keyvault_id,
    try(var.keyvaults[each.value.keyvault_lz_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.client_config.landingzone_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.keyvault_key].id, null),
  )

  access_policy = each.value
  tenant_id     = coalesce(each.value.tenant_id, var.client_config.tenant_id)
  object_id = coalesce(
    try(var.resources.app_registrations[each.value.lz_key][each.value.enterprise_application_key].service_principal_object_id, null),
    try(var.resources.app_registrations[var.client_config.landingzone_key][each.value.enterprise_application_key].service_principal_object_id, null),
    try(var.resources.app_registrations[each.value.enterprise_application_key].service_principal_object_id, null),
  )
}

module "azuread_service_principals" {
  source = "./access_policy"
  for_each = {
    for key, access_policy in var.access_policies : key => access_policy
    if try(access_policy.azuread_service_principal_key, null) != null
  }

  keyvault_id = coalesce(
    var.keyvault_id,
    try(var.keyvaults[each.value.keyvault_lz_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.client_config.landingzone_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.keyvault_key].id, null),
  )

  access_policy = each.value
  tenant_id = coalesce(
    var.resources.azuread_service_principals[try(each.value.lz_key, null)][each.value.azuread_service_principal_key].tenant_id,
    var.client_config.tenant_id
  )

  object_id = coalesce(
    try(var.resources.azuread_service_principals[each.value.lz_key][each.value.azuread_service_principal_key].object_id, null),
    try(var.resources.azuread_service_principals[var.client_config.landingzone_key][each.value.azuread_service_principal_key].object_id, null),
    try(var.resources.azuread_service_principals[each.value.azuread_service_principal_key].object_id, null),
  )
}


module "logged_in_identity" {
  source = "./access_policy"
  for_each = {
    for key, access_policy in var.access_policies : key => access_policy
    if key == "logged_in_identity"
  }

  keyvault_id = coalesce(
    var.keyvault_id,
    try(var.keyvaults[each.value.keyvault_lz_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.client_config.landingzone_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.keyvault_key].id, null),
  )
  access_policy = each.value
  tenant_id     = coalesce(each.value.tenant_id, var.client_config.tenant_id)
  object_id     = var.client_config.object_id
}

module "object_id" {
  source = "./access_policy"
  for_each = {
    for key, access_policy in var.access_policies : key => access_policy
    if access_policy.object_id != null
  }

  keyvault_id = coalesce(
    var.keyvault_id,
    try(var.keyvaults[each.value.keyvault_lz_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.client_config.landingzone_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.keyvault_key].id, null),
  )

  access_policy = each.value
  tenant_id     = coalesce(each.value.tenant_id, var.client_config.tenant_id)
  object_id     = each.value.object_id
}

module "managed_identity" {
  source = "./access_policy"
  for_each = {
    for key, access_policy in var.access_policies : key => access_policy
    if access_policy.managed_identity_key != null
  }

  keyvault_id = coalesce(
    var.keyvault_id,
    try(var.keyvaults[each.value.keyvault_lz_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.client_config.landingzone_key][var.keyvault_key].id, null),
    try(var.keyvaults[var.keyvault_key].id, null),
  )

  access_policy = each.value
  tenant_id = coalesce(
    try(var.resources.managed_identities[each.value.lz_key][each.value.managed_identity_key].tenant_id, null),
    try(var.resources.managed_identities[var.client_config.landingzone_key][each.value.managed_identity_key].tenant_id, null),
    try(var.resources.managed_identities[each.value.managed_identity_key].tenant_id, null),
  )

  object_id = coalesce(
    try(var.resources.managed_identities[each.value.lz_key][each.value.managed_identity_key].principal_id, null),
    try(var.resources.managed_identities[var.client_config.landingzone_key][each.value.managed_identity_key].principal_id, null),
    try(var.resources.managed_identities[each.value.managed_identity_key].principal_id, null),
  )
}
