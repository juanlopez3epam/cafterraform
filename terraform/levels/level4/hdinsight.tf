module "hdinsight" {
  source = "../../modules/compute/hdinsight"

  depends_on = [
    module.storage_accounts,
    module.resource_groups,
    module.keyvaults,
    module.dynamic_keyvault_secrets,
    module.mssql_servers,
    module.mssql_databases,
    module.subnets,
    module.route_tables,
    module.routes,
    azurerm_subnet_route_table_association.rt
  ]

  for_each = local.hdinsight_clusters

  global_settings     = var.global_settings
  client_config       = local.client_config
  settings            = each.value
  resource_groups     = local.consolidated_objects_resource_groups
  storage_accounts    = local.consolidated_objects_storage_accounts
  keyvaults           = local.consolidated_objects_keyvaults
  key_vault_secrets   = module.dynamic_keyvault_secrets
  mssql_servers       = local.consolidated_objects_mssql_servers
  vnets               = local.virtual_networks
  diagnostic_profiles = each.value.diagnostic_profiles
  diagnostics         = local.diagnostics
}
