locals {

  high_availability_local = {
    mode = "ZoneRedundant"
  }
  postgresql_flexible_servers-high_availability-enabled = {
    
  }
  sample_replica_creation_enabled = {
    replica1 = strcontains(var.postgresql_flexible_servers-sample-sku_name, "B") ? false : true
    replica2 = strcontains(var.postgresql_flexible_servers-sample-sku_name, "B") ? false : var.create-postgresql_flexible_servers-sample_sync_replica
    replica3 = strcontains(var.postgresql_flexible_servers-sample-sku_name, "B") ? false : var.create-postgresql_flexible_servers-sample_sync_replica_ha
  }

  filtered_postgresql_flexible_servers = {
    for key, server in local.postgresql_flexible_servers : key => server
    if server != null
  }

  # Explicitly define the order of replicas
  ordered_replicas_keys = [
    "replica_2",
    "replica_3",
  ]

  ordered_replicas = {
    for idx, key in local.ordered_replicas_keys : key => {
      index  = idx
      config = lookup(local.filtered_postgresql_flexible_servers, key, "")
    }
  }

  postgresql_flexible_servers = {
    
    sample = {
      name                          = "jasper"
      region                        = "region1"
      version                       = var.postgresql-jasper-version
      sku_name                      = var.postgresql-jasper-sku_name
      storage_mb                    = var.postgresql-jasper-storage_mb
      public_network_access_enabled = var.postgresql_flexible_servers-public_network_access_enabled
      resource_group_key            = "data_re1"
      keyvault_key                  = "postgres"
      zone                          = var.postgresql-jasper-zone
      backup_retention_days         = var.postgresql_flexible_servers-backup_retention_days
      geo_redundant_backup_enabled  = var.postgresql_flexible_servers-geo_redundant_backup_enabled
      administrator_password_configuration = {
        special     = false
        min_special = 0
      }
      authentication = {
        active_directory_auth_enabled = true
        password_auth_enabled         = true
      }
      postgres_aad_administrators = {
        mdm_aad_admin = {
          object_id      = var.postgres-aad_group-object_id
          principal_name = "miadmin"
          principal_type = "Group"
        }
      }
      postgresql_firewall_rules = {
        allow-azure-services = {
          name             = "allow-azure-services"
          start_ip_address = "0.0.0.0"
          end_ip_address   = "0.0.0.0"
        }
      }
      postgresql_databases = {
        # postgresql_database = {
        #   name = "sampledb"
        # }
      }
      postgresql_configurations = {
        az_extensions = {
          name  = "azure.extensions"
          value = "pg_hint_plan,pg_repack,pg_stat_statements,pgaudit,pgcrypto,pgstattuple,plpgsql,uuid-ossp,hypopg"
        }
        intelligent_tuning = {
          name  = "intelligent_tuning" #https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-intelligent-tuning
          value = "on"
        }
        log_lock_waits = {
          name  = "log_lock_waits"
          value = "on"
        }
        metrics_collector_database_activity = {
          name  = "metrics.collector_database_activity" #https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-monitoring#enabling-enhanced-metrics
          value = "on"
        }
        metrics_autovacuum_diagnostics = {
          name  = "metrics.autovacuum_diagnostics" #https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-monitoring#autovacuum-metrics
          value = "on"
        }
        metrics_pgbouncer_diagnostics = {
          name  = "metrics.pgbouncer_diagnostics" #https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-monitoring#pgbouncer-metrics
          value = "on"
        }
        password_encryption = {
          name  = "password_encryption"
          value = "scram-sha-256"
        }
        pgms_wait_sampling_query_capture_mode = {
          name  = "pgms_wait_sampling.query_capture_mode" #https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-query-store#enable-query-store-wait-sampling
          value = "all"
        }
        pg_qs_query_capture_mode = {
          name  = "pg_qs.query_capture_mode" #https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-query-store#enable-query-store
          value = "all"
        }
        pg_qs_store_query_plans = {
          name  = "pg_qs.store_query_plans" #https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-query-store#configuration-options
          value = "on"
        }
        pg_stat_statements_track = {
          name  = "pg_stat_statements.track"
          value = "all"
        }
        track_io_timing = {
          name  = "track_io_timing"
          value = "on"
        }
      }
      tags = local.sampleorg_tags
      diagnostic_profiles = {
        central_logs = {
          definition_key   = "postgresql"
          destination_type = "log_analytics"
          destination_key  = "central_logs_legacy"
        }
      }
      vnet_integration = {
        subnet_key = "pg_jasper"
      }
      dns_zone = {
        dns_zone_key = "postgres"
        lz_key       = "local" # This is currently the name of the L3 lz_key
      }
      high_availability = local.postgresql_flexible_servers-high_availability-enabled["jasper"] ? local.high_availability_local : null
      # high_availability = {
      #   mode = "ZoneRedundant"
      # }
    }
  }

}