current_landingzone_key = "stg_lvl4"

# ==================================================================
# Terraform Remote State
# ==================================================================
remote_state-resource_group_name = "ford-uk1-uks-terraform-rg"
remote_state-storage_account_name = "uk1uksfordtfbe01"

# ==================================================================
# Elastic Cloud
# ==================================================================
elastic_cloud_deployments-elastic_cloud_cluster-name = "uk1_uks_es"
elastic_cloud_deployments-elastic_cloud_cluster-region = "azure-uksouth"
elastic_cloud_deployments-elastic_cloud_cluster-deployment_template_id = "azure-general-purpose"


# ==================================================================
# Postgres
# ==================================================================
storage_accounts-dbmanager_storage-name = "uk1uksglobalstorage"



# sample Configuration
postgresql_flexible_servers-sample-version = "13"
postgresql_flexible_servers-sample-zone = "2"
postgresql_flexible_servers-sample_async_replica-zone = "2"
postgresql_flexible_servers-sample_sync_replica-zone = "1"
create-postgresql_flexible_servers-sample_sync_replica = true
postgresql_flexible_servers-sample_sync_replica_ha-zone = "3"
postgresql_flexible_servers-sample-sku_name = "GP_Standard_D4ds_v4"
postgresql_flexible_servers-sample-storage_mb = 131072


# The value should be less than sample-storage_mb
postgresql_flexible_servers-sample-maintenance_work_mem = 524288
# The value should be 40% of RAM and in 8k units, ex: RAM - 64G -> 40% = (25.6 * 1024 * 1024) / 8 = 3355443
postgresql_flexible_servers-sample-shared_buffers = "795821"
# The value should be 50% of RAM and in 8k units, ex: RAM - 64G -> 50% = (32 * 1024 * 1024) / 8 = 4194304
postgresql_flexible_servers-sample-effective_cache_size = "994777"


# sample1 Configuration
postgresql_flexible_servers-sample1-version = "13"
postgresql_flexible_servers-sample1-sku_name = "GP_Standard_D2ds_v4"
postgresql_flexible_servers-sample1-storage_mb = 131072
postgresql_flexible_servers-sample1-zone = "1"

postgresql_flexible_servers-sample2-version = "13"
postgresql_flexible_servers-sample2-sku_name = "GP_Standard_D2ds_v4"
postgresql_flexible_servers-sample2-storage_mb = 131072
postgresql_flexible_servers-sample2-zone = "1"


# ==================================================================
# Redis
# ==================================================================
# Primary Configuration
enterprise_redis_clusters-sample_primary-sku_name = "Enterprise_E10-2"
enterprise_redis_clusters-sample_primary-minimum_tls_version = "1.2"

redis_caches-sample_primary-sku_name = "Premium"
redis_caches-sample_primary-capacity = 2
redis_caches-sample_primary-family = "P"
redis_caches-sample_primary-enable_non_ssl_port = false
redis_caches-sample_primary-minimum_tls_version = "1.2"
redis_caches-sample_primary-redis_version = 6

# Checkin Cluster Configuration
sample_device_checkin-sku_name = "Enterprise_E10-2"
sample_device_checkin-minimum_tls_version = "1.2"

create-separate-sample_rate_limiting-cache = false
create-separate-sample_device_checkin-cache = false


# ==================================================================
# Confluent Cloud variables
# ==================================================================



# ==================================================================
# Diagnostics variables
# ==================================================================
diagnostics_definition-redis_all-diagnostics_enabled = true
diagnostics_definition-redis_all-retention_period = 30

diagnostics_definition-enterprise_redis_all-diagnostics_enabled = true
diagnostics_definition-enterprise_redis_all-retention_period = 30

diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled = true
diagnostics_definition-azure_kubernetes_cluster-retention_period = 30

diagnostics_definition-postgresql-diagnostics_enabled = true
diagnostics_definition-postgresql-retention_period = 30

diagnostics_definition-keyvault-diagnostics_enabled = true
diagnostics_definition-keyvault-retention_period = 30

diagnostics_definition-azure_sql-diagnostics_enabled = true
diagnostics_definition-azure_sql-retention_period = 30
