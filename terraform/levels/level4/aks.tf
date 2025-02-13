module "aks" {
  source = "../../modules/compute/aks"

  for_each = local.aks_clusters

  name = each.value.name

  global_settings     = var.global_settings
  client_config       = local.client_config
  settings            = each.value
  resource_group      = local.consolidated_objects_resource_groups[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.resource_group_key]
  vnets               = local.virtual_networks
  managed_identities  = local.consolidated_objects_managed_identities
  diagnostic_profiles = each.value.diagnostic_profiles
  diagnostics         = local.diagnostics
}
