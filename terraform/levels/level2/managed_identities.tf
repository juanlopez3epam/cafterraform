module "managed_identities" {
  source = "../../modules/security/managed_identity"

  for_each        = local.managed_identities
  name            = each.value.name
  settings        = each.value
  global_settings = var.global_settings
  resource_group  = module.resource_groups[each.value.resource_group_key]
}
