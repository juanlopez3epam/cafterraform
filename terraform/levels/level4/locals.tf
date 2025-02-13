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

  level_3 = data.terraform_remote_state.level3.outputs

  virtual_networks = { for k, vnet in local.level_3.vnets["local"] : k => merge(vnet, { subnets = merge(vnet.subnets, module.subnets) }) } #TODO: Make this work for multiple landingzones and additionally support more then one vnet per landingzone

  diagnostics = {
    diagnostics_definition   = try(local.diagnostics_definition, {})
    diagnostics_destinations = try(local.diagnostics_destinations, {})
    log_analytics_workspaces = local.level_3.log_analytics_workspaces["local"]
    eventhub_name                  = local.eventhub_name
    eventhub_authorization_rule_id = local.eventhub_authorization_rule_id
  }
  consolidated_objects_aks_clusters = merge(
    try(local.level_3.aks_clusters, {}),
    tomap({ (local.client_config.landingzone_key) = module.aks })
  )
  consolidated_objects_elastic_cloud_deployments = merge(
    try(local.level_3.elastic_cloud_deployments, {}),
    tomap({ (local.client_config.landingzone_key) = module.elastic_cloud_deployments })
  )
  consolidated_objects_confluent_cloud_deployments = merge(
    try(local.level_3.confluent_cloud_deployments, {}),
    tomap({ (local.client_config.landingzone_key) = module.confluent_cloud_deployments })
  )
  consolidated_objects_enterprise_redis_clusters = merge(
    try(local.level_3.enterprise_redis_clusters, {}),
    tomap({ (local.client_config.landingzone_key) = module.enterprise_redis_clusters })
  )
  consolidated_objects_enterprise_redis_databases = merge(
    try(local.level_3.enterprise_redis_databases, {}),
    tomap({ (local.client_config.landingzone_key) = module.enterprise_redis_databases })
  )
  consolidated_objects_federated_identities = merge(
    try(local.level_3.federated_identities, {}),
    tomap({ (local.client_config.landingzone_key) = module.federated_identities })
  )
  consolidated_objects_keyvaults = merge(
    try(local.level_3.keyvaults, {}),
    tomap({ (local.client_config.landingzone_key) = module.keyvaults })
  )
  consolidated_objects_keyvault_secrets = merge(
    try(local.level_3.keyvault_secrets, {}),
    tomap({ (local.client_config.landingzone_key) = module.keyvault_secrets })
  )
  consolidated_objects_keyvault_dynamic_secrets = merge(
    try(local.level_3.keyvault_dynamic_secrets, {}),
    tomap({ (local.client_config.landingzone_key) = module.dynamic_keyvault_secrets })
  )
  consolidated_objects_managed_identities = merge(
    try(local.level_3.managed_identities, {}),
    tomap({ (local.client_config.landingzone_key) = module.managed_identities })
  )

  consolidated_objects_app_registrations = merge(
    try(local.level_3.app_registrations, {}),
    tomap({ (local.client_config.landingzone_key) = module.app_registrations })
  )
  consolidated_objects_mssql_servers = merge(
    try(local.level_3.mssql_servers, {}),
    tomap({ (local.client_config.landingzone_key) = module.mssql_servers })
  )
  consolidated_objects_networking = merge(
    try(local.level_3.vnets, {}),
  )

  consolidated_objects_postgresql_flexible_servers = merge(
    try(local.level_3.postgresql_flexible_servers, {}),
    tomap({ (local.client_config.landingzone_key) = merge(
      module.postgresql_flexible_server,
      module.postgresql_flexible_server_replicas,
      module.postgresql_flexible_server_pitr
      )
    })
  )
  # consolidated_objects_redis_caches = merge(
  #   try(local.level_3.redis_caches, {}),
  #   tomap({ (local.client_config.landingzone_key) = module.redis_cache })
  # )
  consolidated_objects_resource_groups = merge(
    try(local.level_3.resource_groups, {}),
    tomap({ (local.client_config.landingzone_key) = module.resource_groups })
  )
  consolidated_objects_route_tables = merge(
    try(local.level_3.route_tables, {}),
    tomap({ (local.client_config.landingzone_key) = module.route_tables })
  )
  consolidated_objects_storage_accounts = merge(
    try(local.level_3.storage_accounts, {}),
    tomap({ (local.client_config.landingzone_key) = module.storage_accounts })
  )
  consolidated_objects_private_dns_zones = try(local.level_3.private_dns_zones, {})

  consolidated_objects_subnets = merge(
    # TODO: Get subnets from L3 and above
    # try(local.level_3.subnets, {}),
    tomap({ (local.client_config.landingzone_key) = module.subnets })
  )


  remote_state = {
    resource_group_name  = var.remote_state-resource_group_name
    storage_account_name = var.remote_state-storage_account_name
    container_name       = "level3"
    key                  = "state"
  }

  current_landingzone_key = "stg_lvl4"

  sampleorg_tags = try(local.level_3.sampleorg_tags, {})

  resource_groups = {
    crl_host_re1 = {
      name = "sp-crlhost"
      tags = local.sampleorg_tags
  }

  managed_identities = {
    vault_wi = {
      name               = "c360dc-wi"
      resource_group_key = "security_re1"
    }
  }

  app_registrations = {
    vault_wi_client = {
      name = "vault-wi-client"
    }
  }

  federated_identities = {
    sample_wi = {
      sample_fi = {
        name                  = "sample-wi"
        resource_group_key    = "security_re1"
        managed_identity_key  = "sample_wi"
        kubernetes_issuer_key = "cluster_re1"
        subject               = "system:serviceaccount:default:sample"
      }
    }
  }

 
  sample_primary_cache = {
    sample_primary = {
      name                = "sample-primary"
      resource_group_key  = "cache_re1"

      zones               = [1, 2, 3]
      diagnostic_profiles = {
        central_logs = {
          definition_key   = "enterprise_redis_all"
          destination_type = "log_analytics"
          destination_key  = "central_logs_dedicated"
        }
      }
      private_endpoints = {
        cache_re1_pe = {
          name = "redis-sample-primary"
          subnet = {
            subnet_key = "pvt"
          }
          private_service_connection = {
            subresource_names = ["redisEnterprise"]
          }
          private_dns = {
            pe = {
              dns_zone_key = "privatelink.redisenterprise.cache.azure.net"
              lz_key       = "core_lvl2"
            }
          }
        }
      }
    }
  }

  subnets = {
    pvt = {
      name     = "private-endpoints",
      vnet_key = "vnet-01",
      lz_key   = "local"
      cidr     = var.subnets-pvt-cidr
    }
  }

  route_tables = {
    confluent = {
      name               = "snet-confluent"
      lz_key             = "local"
      resource_group_key = "vnet-01"
    }
  }

  routes = {

  }

  storage_accounts = {
    crl_host_storage = {
      name                            = "crlhost"
      resource_group_key              = "crl_host_re1"
      account_kind                    = "StorageV2"
      account_tier                    = "Standard"
      account_replication_type        = var.storage_accounts-crl_repplication_type
      access_tier                     = "Hot"
      enable_https_traffic_only       = true
      allow_nested_items_to_be_public = true
      public_network_access_enabled   = true
      containers = {
        crl_container = {
          name        = "crlcontainer"
          access_type = "blob"
        }
      }
    }
  }

  hdinsight_clusters = {
    # primary = {
    #   tags = {
    #     privatedns = var.hdinsight_clusters-primary-tags-privatedns
    #   }
    #   name                = "primary"
    #   resource_group_key  = "kafka_re1"
    #   storage_account_key = "kafka_file_system"
    #   container_key       = "fs"
    #   keyvault_key        = "kafka"
    #   cluster_version     = var.hdinsight_clusters-primary-cluster_version
    #   component_version   = var.hdinsight_clusters-primary-cluster_component_version
    #   vnet_key            = "hdinsights"
    #   vnet_subnet_key     = "hdinsights"
    #   administrator_password_configuration = {
    #     special     = true
    #     min_special = 1
    #   }
    #   encryption = {
    #     at_host_enabled    = false
    #     in_transit_enabled = false
    #   }
    #   gateway = {
    #     username = "acctestusrgw"
    #   }
    #   roles = {
    #     head_node = {
    #       vm_size = var.hdinsight_clusters-primary-roles-head_node-vm_size
    #     }
    #     worker_node = {
    #       vm_size                  = var.hdinsight_clusters-primary-roles-worker_node-vm_size
    #       number_of_disks_per_node = var.hdinsight_clusters-primary-roles-worker-number_of_disks_per_node
    #       target_instance_count    = var.hdinsight_clusters-primary-roles-worker-target_instance_count
    #     }
    #     zookeeper_node = {
    #       vm_size = var.hdinsight_clusters-primary-roles-zookeeper_node-vm_size
    #     }
    #   }
    #   metastores = {
    #     hive = {
    #       server_key                   = "hdinsight_metastore"
    #       database_name                = "hive"
    #       username                     = "metastoreadmin"
    #       password_keyvault_secret_key = "hdinsight_metastore_password"
    #     }
    #     oozie = {
    #       server_key                   = "hdinsight_metastore"
    #       database_name                = "oozie"
    #       username                     = "metastoreadmin"
    #       password_keyvault_secret_key = "hdinsight_metastore_password"
    #     }
    #     ambari = {
    #       server_key                   = "hdinsight_metastore"
    #       database_name                = "ambari"
    #       username                     = "metastoreadmin"
    #       password_keyvault_secret_key = "hdinsight_metastore_password"
    #     }
    #   }
    #   diagnostic_profiles = {
    #     central_logs = {
    #       definition_key   = "hd_insight"
    #       destination_type = "log_analytics"
    #       destination_key  = "central_logs_dedicated"
    #     }
    #   }
    #   log_analytics_workspace_key = "law1"
    # }
  }

}