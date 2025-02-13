module "mssql_servers" {
  source = "../../modules/databases/mssql_server"

  for_each = local.mssql_servers

  global_settings  = var.global_settings
  client_config    = local.client_config
  settings         = each.value
  resource_groups  = local.consolidated_objects_resource_groups
  vnets            = local.virtual_networks
  key_vault_secret = module.dynamic_keyvault_secrets[each.value.key_vault_secret_key]
}

module "mssql_databases" {
  source = "../../modules/databases/mssql_database"

  for_each = local.mssql_databases

  global_settings = var.global_settings
  settings        = each.value
  server          = module.mssql_servers[each.value.server_key]
}
