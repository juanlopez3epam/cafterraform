module "dynamic_keyvault_secrets" {
  source = "../../modules/security/keyvault_dynamic_secrets"

  for_each = local.dynamic_keyvault_secrets

  global_settings = var.global_settings
  settings        = each.value
  keyvault        = local.consolidated_objects_keyvaults[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.keyvault_key]
}


module "keyvault_template_secrets" {
  source = "../../modules/security/keyvault_template_secrets"

  for_each        = local.keyvault_template_secrets
  global_settings = var.global_settings
  client_config   = local.client_config
  settings        = each.value
  keyvault        = local.consolidated_objects_keyvaults[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.keyvault_key]
  level_path      = path.module

  resources = {
    keyvault_dynamic_secrets     = local.consolidated_objects_keyvault_dynamic_secrets
    keyvault_secrets             = local.consolidated_objects_keyvault_secrets
    postgresql_flexible_servers  = local.consolidated_objects_postgresql_flexible_servers
    redis_caches                 = local.consolidated_objects_redis_caches
    enterprise_redis_clusters    = local.consolidated_objects_enterprise_redis_clusters
    enterprise_redis_databases   = local.consolidated_objects_enterprise_redis_databases
    elasticsearch_security_users = local.consolidated_objects_elasticsearch_security_users
    elastic_cloud_deployments    = local.consolidated_objects_elastic_cloud_deployments
    confluent_cloud_deployments  = local.consolidated_objects_confluent_cloud_deployments
    storage_accounts             = local.consolidated_objects_storage_accounts
  }
  depends_on = [
    module.dynamic_keyvault_secrets,
    module.elasticsearch_security_user
  ]
}
