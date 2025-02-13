module "managed_identities" {
  source = "../../modules/security/managed_identity"

  for_each        = local.managed_identities
  name            = each.value.name
  settings        = each.value
  global_settings = var.global_settings
  resource_group  = try(each.value.lz_key, null) == null ? local.consolidated_objects_resource_groups[local.client_config.landingzone_key][each.value.resource_group_key] : local.consolidated_objects_resource_groups[each.value.lz_key][each.value.resource_group_key]
}
