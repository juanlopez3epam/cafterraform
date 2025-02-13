
module "enterprise_redis_clusters" {
  source = "../../modules/redis/enterprise_redis_cluster"

  for_each = local.enterprise_redis_clusters

  global_settings     = var.global_settings
  client_config       = local.client_config
  settings            = each.value
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  base_tags           = module.resource_groups[each.value.resource_group_key].tags
  diagnostic_profiles = each.value.diagnostic_profiles
  diagnostics         = local.diagnostics
  subnets             = local.consolidated_objects_subnets
  dns_zones           = local.consolidated_objects_private_dns_zones
}

module "enterprise_redis_databases" {
  source = "../../modules/redis/enterprise_redis_database"

  for_each = local.enterprise_redis_databases

  global_settings = var.global_settings
  settings        = each.value
  redis_cluster   = module.enterprise_redis_clusters
}

module "private_endpoints" {
  source   = "../../modules/networking/private_endpoint"
  for_each = local.enterprise_redis_clusters

  global_settings     = var.global_settings
  client_config       = local.client_config
  subnets             = local.consolidated_objects_subnets
  dns_zones           = local.consolidated_objects_private_dns_zones
  resource_id         = module.enterprise_redis_clusters[each.key].id
  resource_group_name = module.enterprise_redis_clusters[each.key].resource_group_name
  location            = module.enterprise_redis_clusters[each.key].location
  settings            = local.private_endpoints[each.key]

  depends_on = [
    module.enterprise_redis_databases
  ]
}