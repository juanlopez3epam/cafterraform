locals {
  object_id = coalesce(var.logged_user_object_id, var.logged_aad_app_object_id, try(data.azurerm_client_config.current.object_id, null), try(data.azuread_service_principal.logged_in_app[0].object_id, null))
  client_config = var.client_config == {} ? {
    client_id                = data.azurerm_client_config.current.client_id
    landingzone_key          = local.current_landingzone_key
    logged_aad_app_object_id = local.object_id
    logged_user_object_id    = local.object_id
    object_id                = local.object_id
    subscription_id          = data.azurerm_client_config.current.subscription_id
    tenant_id                = data.azurerm_client_config.current.tenant_id
  } : map(var.client_config)
  level_4 = data.terraform_remote_state.level4.outputs

  consolidated_objects_enterprise_redis_clusters = merge(
    try(local.level_4.enterprise_redis_clusters, {}),
  )
  consolidated_objects_enterprise_redis_databases = merge(
    try(local.level_4.enterprise_redis_databases, {}),
  )
  consolidated_objects_elastic_cloud_deployments = merge(
    try(local.level_4.elastic_cloud_deployments, {}),
  )
  consolidated_objects_confluent_cloud_deployments = merge(
    try(local.level_4.confluent_cloud_deployments, {}),
  )
  consolidated_objects_elasticsearch_security_users = merge(
    try(local.level_4.elasticsearch_security_users, {}),
    try(tomap({ (local.client_config.landingzone_key) = module.elasticsearch_security_user }), {}),
  )
  consolidated_objects_keyvaults = merge(
    try(local.level_4.keyvaults, {}),
  )
  consolidated_objects_keyvault_secrets = merge(
    try(local.level_4.keyvault_secrets, {}),
  )
  consolidated_objects_keyvault_dynamic_secrets = merge(
    try(local.level_4.keyvault_dynamic_secrets, {}),
    try(tomap({ (local.client_config.landingzone_key) = module.dynamic_keyvault_secrets }), {}),
  )
  consolidated_objects_keyvault_template_secrets = merge(
    try(local.level_4.keyvault_template_secrets, {}),
    try(tomap({ (local.client_config.landingzone_key) = module.keyvault_template_secrets }), {}),
  )
  consolidated_objects_postgresql_flexible_servers = merge(
    try(local.level_4.postgresql_flexible_servers, {}),
  )
  consolidated_objects_redis_caches = merge(
    try(local.level_4.redis_caches, {}),
  )
   consolidated_objects_storage_accounts = merge(
    try(local.level_4.storage_accounts, {}),
  )



  remote_state = {
    resource_group_name  = var.remote_state-resource_group_name
    storage_account_name = var.remote_state-storage_account_name
    container_name       = "level4"
    key                  = "state"
  }
  current_landingzone_key = "stg_lvl5"

  provider_elasticstack_elasticsearch = {
    lz_key      = var.lvl4_landingzone_key
    cluster_key = "elastic_cloud_cluster"
  }

  sample_rate_limiting_redis_password_string = var.separate-sample_rate_limiting-cache-enabled ? "sample_rate_limiting_redis_password" : "redis_password"

  sample_device_checkin_redis_password_string = var.separate-sample_device_checkin-cache-enabled ? "sample_device_checkin_redis_password" : "redis_password"

  enterprise_redis_db_sample = {
    sample = {
      lz_key = var.lvl4_landingzone_key
      primary_access_key = {
        template_keys = ["redis_password"]
      }
    }
  }



  dynamic_keyvault_secrets = {
    elasticsearch_sample_application_user_password = {
      keyvault_key = "sample"
      lz_key       = var.lvl4_landingzone_key
      secret_name  = "sample-elasticsearch-app-user-password"
      config = {
        length           = 32
        upper            = true
        numeric          = true
        special          = true
        min_lower        = 1
        min_numeric      = 1
        min_special      = 1
        min_upper        = 1
        override_special = "_!#"
      }
    }
  }
}
