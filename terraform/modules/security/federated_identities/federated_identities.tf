module "kubernetes_federated_identities" {
  source = "./federated_identity"

  for_each = {
    for key, federated_identity in var.settings : key => federated_identity
    if try(federated_identity.kubernetes_issuer_key, null) != null
  }

  global_settings = var.global_settings
  settings        = merge(each.value, { audience = ["api://AzureADTokenExchange"] })
  parent_id = coalesce(
    var.user_assigned_identity_resource_id,
    try(var.resources.managed_identities[each.value.lz_key][each.value.managed_identity_key].id, null),
    try(var.resources.managed_identities[var.client_config.landingzone_key][each.value.managed_identity_key].id, null),
    try(var.resources.managed_identities[each.value.managed_identity_key].id, null),
  )
  issuer = coalesce(
    try(var.resources.aks[each.value.lz_key][each.value.kubernetes_issuer_key].oidc_issuer_url, null),
    try(var.resources.aks[var.client_config.landingzone_key][each.value.managed_identity_key].oidc_issuer_url, null),
    try(var.resources.aks[each.value.kubernetes_issuer_key].oidc_issuer_url, null),
  )
  resource_group_name = coalesce(
    try(var.resource_groups[each.value.lz_key][each.value.resource_group_key].name, null),
    try(var.resource_groups[var.client_config.landingzone_key][each.value.resource_group_key].name, null),
    try(var.resource_groups[each.value.resource_group_key].name, null),
  )
}
