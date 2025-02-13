
module "roles" {
  source = "../../modules/security/roles"

  client_config = local.client_config
  role_mapping  = local.roles
  services_roles = {
    aks_clusters       = local.consolidated_objects_aks_clusters
    #azuread_groups    = local.consolidated_objects_azuread_groups
    #azuread_users     = local.consolidated_objects_azuread_users
    #azuread_service_principals = local.consolidated_objects_azuread_service_principals
    resource_groups    = local.consolidated_objects_resource_groups
    keyvaults          = local.consolidated_objects_keyvaults
    managed_identities = local.consolidated_objects_managed_identities
    networking         = local.consolidated_objects_networking
    #resource_groups   = local.consolidated_objects_resource_groups #TODO: Add support for resource groups after outputs realignment.
    storage_accounts   = local.consolidated_objects_storage_accounts
  }
  custom_roles = null #TODO: Add support for custom roles
}
