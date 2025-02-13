##Dev tf var file to store all the dev peroperties and their values

current_landingzone_key = "stg_lvl4"

aks_clusters-cluster_re1-pool1-vm_size = "Standard_D16ds_v4"

# ==================================================================
# Terraform Remote State
# ==================================================================
remote_state-resource_group_name = "sampleorg-dd-eus-mdm-tfbe-rg"
remote_state-storage_account_name = "ivaddeusmdmtfbe01"


# ==================================================================
# HDinsights
# ==================================================================
hdinsight_clusters-primary-tags-privatedns = "hdinsights.fordteam1-eastus.mi.sampleorg.io"


# ==================================================================
# Diagnostics variables
# ==================================================================
diagnostics_definition-redis_all-diagnostics_enabled = false
diagnostics_definition-redis_all-retention_period = 7

diagnostics_definition-enterprise_redis_all-diagnostics_enabled = false
diagnostics_definition-enterprise_redis_all-retention_period = 7

diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled = false
diagnostics_definition-azure_kubernetes_cluster-retention_period = 7

diagnostics_definition-postgresql-diagnostics_enabled = false
diagnostics_definition-postgresql-retention_period = 7

diagnostics_definition-keyvault-diagnostics_enabled = false
diagnostics_definition-keyvault-retention_period = 7

diagnostics_definition-hd_insight-diagnostics_enabled = false
diagnostics_definition-hd_insight-retention_period = 7

diagnostics_definition-azure_sql-diagnostics_enabled = false
diagnostics_definition-azure_sql-retention_period = 7

# ==================================================================
# Redis variables
# ==================================================================
create-separate-sample_rate_limiting-cache = false
create-separate-sample_device_checkin-cache = false

elastic_cloud_deployments-elastic_cloud_cluster-name = "fordteam1_mi_cl"

# ==================================================================
# Confluent Cloud variables
# ==================================================================

confluent_cloud_deployments-kafka_cluster-display_name = "dedicated_kafka_dap_dev_1"
confluent_cloud_deployments-kafka_cluster-env_display_name = "fordteam-1"