module "federated_identities" {
  source = "../../modules/security/federated_identities"

  for_each = local.federated_identities

  settings        = each.value
  global_settings = var.global_settings
  client_config   = local.client_config
  resource_groups = local.consolidated_objects_resource_groups

  resources = {
    aks                = module.aks
    managed_identities = module.managed_identities
  }
}
