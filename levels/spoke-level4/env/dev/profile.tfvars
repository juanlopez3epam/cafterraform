## Dev profile tf var file to store all the Dev peroperties and their values

# ==================================================================
# Postgres
# ==================================================================
postgresql_flexible_servers-sample-zone = "2"
postgresql_flexible_servers-sample_async_replica-zone = "3"
postgresql_flexible_servers-sample_sync_replica-zone = "1"
create-postgresql_flexible_servers-sample_sync_replica = true
postgresql_flexible_servers-sample_sync_replica_ha-zone = "2"
create-postgresql_flexible_servers-sample_sync_replica_ha = true


# ==================================================================
# Redis variables
# ==================================================================
create-separate-sample_rate_limiting-cache = false
create-separate-sample_device_checkin-cache = false

# ==================================================================
# Confluent Cloud variables
# ==================================================================
confluent_cloud_deployments-kafka_cluster-availability = "SINGLE_ZONE"
confluent_cloud_deployments-kafka_cluster-cloud = "AZURE"
confluent_cloud_deployments-kafka_cluster-region = "eastus" 
# ==================================================================
# Elastic Cloud Variables
# ==================================================================

# ==================================================================
# CRL
# ==================================================================
storage_accounts-crl_repplication_type = "LRS"
cdn-crl_sku = "Standard_Microsoft"

create-public_ip_address-kong-lb = true


# ==================================================================
# Cast AI
# ==================================================================

castai_enabled = true
cast_ai_read_only = false
deployment_sp_id = ""        # This is the service principal (object) id created for the deployment in Jenkins
castai_sp_id = ""            # This is the service principal (object) id created for the castai
castai_app_clinet_id = ""    # This is the client (application) id of the service principal created for the castai
castai_autoscaler_policies_enabled = true                           # This is the flag to enable or disable the autoscaler policies
castai-node_downscaler-evictor-dry_run = false                       # This is the flag to enable or disable the dry run for the evictor
castai-autoscaler_settings-evictor-enabled = true                   # This is the flag to enable or disable the evictor
evictor_aggresive_mode_enabled = true                               # This is the flag to enable or disable the aggressive mode for the evictor - will evict single replica pods if enabled    
castai_rebalancing_schedule_id = "" # use API here to get UUID: https://docs.cast.ai/reference/scheduledrebalancingapi_listrebalancingschedules
castai_rebalancing_schedule_enabled = true                        # This is the flag to enable or disable the rebalancing schedule
castai-cluster_limits-cpu-maxCores = 100                            # This is the maximum number of CPU cores that can be used by the cluster
castai-autoscaler_settings-node_downscaler-enabled = true           # This is the flag to enable or disable the node downscaler
