## Production profile tf var file to store all the common production properties and their values

# ==================================================================
# Postgres
# ==================================================================
postgresql_flexible_servers-sample-zone = "2"
postgresql_flexible_servers-sample_async_replica-zone = "3"

postgresql_flexible_servers-sample-storage_mb = 2097152
postgresql_flexible_servers-backup_retention_days = 35
postgresql_flexible_servers-geo_redundant_backup_enabled = false

# The value should be less than sample-storage_mb
postgresql_flexible_servers-sample-maintenance_work_mem = 2097151
# The value should be 40% of RAM and in 8k units, ex: RAM - 64G -> 40% = (25.6 * 1024 * 1024) / 8 = 3355443
postgresql_flexible_servers-sample-shared_buffers = "10066329"
# The value should be 50% of RAM and in 8k units, ex: RAM - 64G -> 50% = (32 * 1024 * 1024) / 8 = 4194304
postgresql_flexible_servers-sample-effective_cache_size = "12582912"



# ==================================================================
storage_accounts-dbmanager_storage-name = "nmdmdbmgrglobal"

# ==================================================================
# Confluent Cloud variables
# ==================================================================
confluent_cloud_deployments-kafka_cluster-availability = "MULTI_ZONE"
confluent_cloud_deployments-kafka_cluster-cloud = "AZURE"
confluent_cloud_deployments-kafka_cluster-region = "eastus" 
confluent_cloud_deployments-kafka_cluster-cku = 3 #at least 2 for multizone cluster


# ==================================================================
# CRL
# ==================================================================
storage_accounts-crl_repplication_type = "GRS"

# ==================================================================
# Cast AI
# ==================================================================

aks_clusters-cluster_re1-default_node_pool-enable_auto_scaling = true  # set this to false when cast ai is enabled
aks_clusters-cluster_re1-pool1-enable_auto_scaling = true              # set this to false when cast ai is enabled
castai_enabled = false
cast_ai_read_only = false
deployment_sp_id = ""        # This is the service principal (object) id created for the deployment in Jenkins
castai_sp_id = ""            # This is the service principal (object) id created for the castai
castai_app_clinet_id = ""    # This is the client (application) id of the service principal created for the castai
castai_autoscaler_policies_enabled = false                           # This is the flag to enable or disable the autoscaler policies
castai-node_downscaler-evictor-dry_run = true                       # This is the flag to enable or disable the dry run for the evictor
castai-autoscaler_settings-evictor-enabled = false                   # This is the flag to enable or disable the evictor
evictor_aggresive_mode_enabled = false                               # This is the flag to enable or disable the aggressive mode for the evictor - will evict single replica pods if enabled    
castai-cluster_limits-cpu-maxCores = 300
