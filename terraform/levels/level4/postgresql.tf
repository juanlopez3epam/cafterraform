module "postgresql_flexible_server" {
  source = "../../modules/databases/postgresql_flexible_server"

  for_each = {
    for key, postgresql_flexible_server in local.filtered_postgresql_flexible_servers : key => postgresql_flexible_server
    if lookup(postgresql_flexible_server, "create_mode", null) == "Default" || lookup(postgresql_flexible_server, "create_mode", null) == null
  }

  global_settings     = var.global_settings
  client_config       = local.client_config
  settings            = each.value
  resource_groups     = local.consolidated_objects_resource_groups
  keyvaults           = local.consolidated_objects_keyvaults
  subnets             = local.consolidated_objects_subnets
  private_dns_zones   = local.consolidated_objects_private_dns_zones
  diagnostic_profiles = each.value.diagnostic_profiles
  diagnostics         = local.diagnostics
  depends_on = [
    module.keyvaults,
    module.subnets
  ]

}

module "postgresql_flexible_server_replicas" {
  source = "../../modules/databases/postgresql_flexible_server"

  for_each = {
    for key, postgresql_flexible_server in local.filtered_postgresql_flexible_servers : key => postgresql_flexible_server
    if lookup(postgresql_flexible_server, "create_mode", null) == "Replica"
  }
  global_settings                    = var.global_settings
  client_config                      = local.client_config
  settings                           = each.value
  resource_groups                    = local.consolidated_objects_resource_groups
  keyvaults                          = local.consolidated_objects_keyvaults
  subnets                            = local.consolidated_objects_subnets
  private_dns_zones                  = local.consolidated_objects_private_dns_zones
  source_postgresql_flexible_servers = module.postgresql_flexible_server
  diagnostic_profiles                = each.value.diagnostic_profiles
  diagnostics                        = local.diagnostics

  depends_on = [
    module.keyvaults,
    module.postgresql_flexible_server,
    module.subnets
  ]
}

module "postgresql_flexible_server_pitr" {
  source = "../../modules/databases/postgresql_flexible_server"

  for_each = {
    for key, postgresql_flexible_server in local.filtered_postgresql_flexible_servers : key => postgresql_flexible_server
    if lookup(postgresql_flexible_server, "create_mode", null) == "PointInTimeRestore"
  }
  global_settings                    = var.global_settings
  client_config                      = local.client_config
  settings                           = each.value
  resource_groups                    = local.consolidated_objects_resource_groups
  keyvaults                          = local.consolidated_objects_keyvaults
  subnets                            = local.consolidated_objects_subnets
  private_dns_zones                  = local.consolidated_objects_private_dns_zones
  source_postgresql_flexible_servers = module.postgresql_flexible_server
  diagnostic_profiles                = each.value.diagnostic_profiles
  diagnostics                        = local.diagnostics

  depends_on = [
    module.keyvaults,
    module.postgresql_flexible_server,
    module.subnets
  ]
}
