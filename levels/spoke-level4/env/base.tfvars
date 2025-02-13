# Base tf var file to store all the base peroperties and their values
# ==================================================================
# Landing Zone key
# ==================================================================
current_landingzone_key = "local_lvl4"

# ==================================================================
# Terraform Remote State
# ==================================================================
remote_state-resource_group_name = ""
remote_state-storage_account_name = ""

# ==================================================================
# AKS
# ==================================================================

aks_clusters-cluster_re1-kubernetes_version = "1.30.5"
aks_clusters-cluster_re1-sku_tier = "Free"
aks_clusters-cluster_re1-default_node_pool-vm_size = "Standard_D4ds_v4"
aks_clusters-cluster_re1-default_node_pool-enable_auto_scaling = true
aks_clusters-cluster_re1-default_node_pool-min_count = 1
aks_clusters-cluster_re1-default_node_pool-max_count = 3
aks_clusters-cluster_re1-default_node_pool-os_disk_size_gb = 150
aks_clusters-cluster_re1-default_node_pool-availability_zones = [1, 2, 3]

aks_clusters-cluster_re1-pool1-vm_size = "Standard_D8ds_v4"
aks_clusters-cluster_re1-pool1-enable_auto_scaling = true
aks_clusters-cluster_re1-pool1-min_count = 1
aks_clusters-cluster_re1-pool1-max_count = 12
aks_clusters-cluster_re1-pool1-os_disk_size_gb = 150
aks_clusters-cluster_re1-pool1-availability_zones= [1, 2, 3]

# Set outbound_ip_address_ids to an empty slice [] in order to unlink it from the cluster. Unlinking a outbound_ip_address_ids will revert the load balancing for the cluster back to a managed one.
aks_clusters-cluster_re1-outbound_ip_prefix_ids = []
aks_clusters-cluster_re1-api_server_authorized_ip_ranges = []
aks_clusters-cluster_re1-node_os_upgrader_option  = "None"

# ==================================================================
# Elastic Cloud
# ==================================================================
elastic_cloud_deployments-elastic_cloud_cluster-name = "dapqe2_mi_cluster"
elastic_cloud_deployments-elastic_cloud_cluster-region = "azure-eastus"
elastic_cloud_deployments-elastic_cloud_cluster-version = "7.17.0"
elastic_cloud_deployments-elastic_cloud_cluster-size_per_zone = "8g"
elastic_cloud_deployments-elastic_cloud_cluster-deployment_template_id = "azure-general-purpose"
elastic_cloud_deployments-runner_pvt_endpoint_subnet_name = "confluentkafkapvtendpointsubnet"
elastic_cloud_deployments-runner_subscription_id = "c49ee34f-de27-4fe2-8a75-0c7cd031ea6e"
elastic_cloud_deployments-runner_resource_group = "Github-Action-Runner-SaaS-MICloud"
elastic_cloud_deployments-runner_region = "eastus"
elastic_cloud_deployments-runner_vnet = "runner-vnet"
elastic_cloud_deployments-runner_create_private_network = false

# ==================================================================
# Keyvault
# ==================================================================
keyvault-aad_group-object_id = "57c09f27-8c93-4fc9-abf3-97476c6d1124"

# ==================================================================
# Postgres
# ==================================================================
postgres-aad_group-object_id = "57c09f27-8c93-4fc9-abf3-97476c6d1124"

postgresql_flexible_servers-backup_retention_days = 7
postgresql_flexible_servers-geo_redundant_backup_enabled = false
postgresql_flexible_servers-public_network_access_enabled = false

postgresql_flexible_servers-auriga-high_availability-enabled = false
postgresql_flexible_servers-sample-high_availability-enabled = false
postgresql_flexible_servers-jasper-high_availability-enabled = false
postgresql_flexible_servers-kong-high_availability-enabled = false
postgresql_flexible_servers-aquila-high_availability-enabled = false
postgresql_flexible_servers-vault2-high_availability-enabled = false

postgresql_flexible_servers-auriga-version = "13"
postgresql_flexible_servers-auriga-sku_name = "GP_Standard_D2ds_v4"
postgresql_flexible_servers-auriga-storage_mb = 131072
postgresql_flexible_servers-auriga-zone = "1"

postgresql_flexible_servers-sample-version = "16"
postgresql_flexible_servers-sample-sku_name = "GP_Standard_D16ds_v4"
postgresql_flexible_servers-sample-storage_mb = 131072
postgresql_flexible_servers-sample-zone = "2"
postgresql_flexible_servers-sample_async_replica-zone = "3"
postgresql_flexible_servers-sample_sync_replica-zone = "1"
create-postgresql_flexible_servers-sample_sync_replica = false
postgresql_flexible_servers-sample_sync_replica_ha-zone = "2"
create-postgresql_flexible_servers-sample_sync_replica_ha = false
# The value should be less than sample-storage_mb
postgresql_flexible_servers-sample-maintenance_work_mem = 131071
# The value should be 40% of RAM and in 8k units, ex: RAM - 64G -> 40% = (25.6 * 1024 * 1024) / 8 = 3355443
postgresql_flexible_servers-sample-shared_buffers = "838860"
# The value should be 50% of RAM and in 8k units, ex: RAM - 64G -> 50% = (32 * 1024 * 1024) / 8 = 4194304
postgresql_flexible_servers-sample-effective_cache_size = "1048576"

postgresql-jasper-version = "16"
postgresql-jasper-sku_name = "GP_Standard_D4ds_v4"
postgresql-jasper-storage_mb = 131072
postgresql-jasper-zone = "3"

postgresql-kong-version = "13"
postgresql-kong-sku_name = "GP_Standard_D2ds_v4"
postgresql-kong-storage_mb = 131072
postgresql-kong-zone = "2"

postgresql-aquila-version = "16"
postgresql-aquila-sku_name = "GP_Standard_D2ds_v4"
postgresql-aquila-storage_mb = 131072
postgresql-aquila-zone = "1"

postgresql-vault2-version = "13"
postgresql-vault2-sku_name = "GP_Standard_D2ds_v4"
postgresql-vault2-storage_mb = 131072
postgresql-vault2-zone = "2"

# ==================================================================
# Routes variables
# ==================================================================
# routes-hd_insights_health_1-name = "168.61.49.99"
# routes-hd_insights_health_2-name = "23.99.5.239"
# routes-hd_insights_health_3-name = "168.61.48.131"
# routes-hd_insights_health_4-name = "138.91.141.162"
# routes-hd_insights_health_regional_1-name = "13.82.225.233"
# routes-hd_insights_health_regional_2-name = "40.71.175.99"

# ==================================================================
# Subnet variables
# ==================================================================
subnets-pvt-cidr = ["10.22.0.0/25"]
subnets-pg_pol-cidr = ["10.22.0.128/28"]
subnets-pg_pol_replica-cidr = ["10.22.0.144/28"]
subnets-pg_jasper-cidr = ["10.22.0.160/28"]
subnets-pg_aquila-cidr = ["10.22.0.176/28"]
subnets-pg_auriga-cidr = ["10.22.0.192/28"]
subnets-pg_pol_replica2-cidr = ["10.22.0.240/28"]
subnets-aks_pool_1-cidr = ["10.22.64.0/18"]
subnets-aks_system-cidr = ["10.22.4.0/23"]
subnets-kafka-pvt-cidr =  ["10.22.128.32/27"]
subnets-hdinsights-cidr = ["10.22.128.0/27"]
subnets-pg_vault2-cidr = ["10.22.0.224/28"]
subnets-pg_kong-cidr = ["10.22.0.208/28"]
subnets-aks_ingress_services-cidr = ["10.22.2.0/24"]
subnets-pg_pol_replica3-cidr = ["10.22.1.0/28"]


# ==================================================================
# RBAC
# ==================================================================
rbac-aad_group-object_id = ["57c09f27-8c93-4fc9-abf3-97476c6d1124"]
rbac-external_resources-acr = "/subscriptions/394f38c2-697f-48c4-9388-57ff0a428ab3/resourceGroups/BuildACR/providers/Microsoft.ContainerRegistry/registries/mibuild"
storage_accounts-dbmanager_storage-name = "qbmdmdbmglobal"

# ==================================================================
# HDInsight
# ==================================================================
# hdinsight_clusters-primary-tags-privatedns = "hdinsights.stamp-eastus.mi.sampleorg.io"
# hdinsight_clusters-primary-roles-head_node-vm_size = "Standard_DS3_V2"
# hdinsight_clusters-primary-roles-worker_node-vm_size = "Standard_E2_V3"
# hdinsight_clusters-primary-roles-zookeeper_node-vm_size = "Standard_DS2_V2"
# hdinsight_clusters-primary-roles-worker-number_of_disks_per_node = 2
# hdinsight_clusters-primary-roles-worker-target_instance_count = 4
# hdinsight_clusters-primary-cluster_version = "5.0"
# hdinsight_clusters-primary-cluster_component_version = "2.4"

# ==================================================================
# Redis
# ==================================================================
enterprise_redis_clusters-sample_primary-sku_name = "Enterprise_E10-2"
enterprise_redis_clusters-sample_primary-minimum_tls_version = "1.2"

sample_device_checkin-sku_name = "Enterprise_E10-2"
sample_device_checkin-minimum_tls_version = "1.2"

sample_rate_limit-sku_name = "Enterprise_E10-2"
sample_rate_limit-minimum_tls_version = "1.2"

create-separate-sample_rate_limiting-cache = false
create-separate-sample_device_checkin-cache = false

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

# diagnostics_definition-hd_insight-diagnostics_enabled = false
# diagnostics_definition-hd_insight-retention_period = 7

diagnostics_definition-azure_sql-diagnostics_enabled = false
diagnostics_definition-azure_sql-retention_period = 7

eventhub_name = null
eventhub_authorization_rule_id = null

# ==================================================================
# Mssql variables
# ==================================================================

# mssql_servers-hdinsight_metastore-location = "eastus"
# mssql_servers-hdinsight_metastore-version = "12.0"
# mssql_servers-hdinsight_metastore-azuread_administrator-object_id = "3fabd666-ad4f-429f-b591-e33b1763b16e"


# ==================================================================
# Confluent Kafka
# ==================================================================
confluent_cloud_deployments-kafka_cluster-env_display_name = "sampleorg"
confluent_cloud_deployments-kafka_cluster-region = "azure-east"
confluent_cloud_deployments-kafka_cluster-availability = "SINGLE_ZONE"
confluent_cloud_deployments-kafka_cluster-display_name = "dedicated_kafka_1"
confluent_cloud_deployments-kafka_cluster-cloud = "AZURE"
confluent_cloud_deployments-kafka_cluster-cku = 1
confluent_cloud_deployments-runner_pvt_endpoint_subnet_name = ""
confluent_cloud_deployments-runner_subscription_id = ""
confluent_cloud_deployments-runner_resource_group = ""
confluent_cloud_deployments-runner_region = "eastus"
confluent_cloud_deployments-runner_vnet = "runner-vnet"

network_restrictions_ip_rule_list = []

# ==================================================================
# CRL
# ==================================================================
storage_accounts-crl_repplication_type = "LRS"
cdn-crl_sku = "Standard_Microsoft"

create-public_ip_address-kong-lb = false


# ==================================================================
# Cast AI
# ==================================================================

aks_clusters-cluster_re1-default_node_pool-enable_auto_scaling = true  # set this to false when cast ai is enabled
aks_clusters-cluster_re1-pool1-enable_auto_scaling = true              # set this to false when cast ai is enabled
castai_enabled = false
cast_ai_read_only = false
deployment_sp_id = ""         # This is the service principal (object) id created for the deployment in Jenkins
castai_sp_id = ""             # This is the service principal (object) id created for the castai
castai_app_clinet_id = ""     # This is the client (application) id of the service principal created for the castai
delete_nodes_on_disconnect = false
castai_autoscaler_policies_enabled = true
node_templates_partial_matching_enabled = false
castai_api_url = "https://api.cast.ai"
castai_agent_version = "0.79.0"
castai_agent_replica = 2
castai_cluster_controller_version = "0.67.0"
castai_cluster_controller_replica = 2
castai_evictor_version = "0.30.18"
castai_evictor_replica = 1
evictor_aggresive_mode_enabled = false
castai_evictor_ext_version = "0.1.0"
castai_pod_pinner_version = "0.6.0"
castai_pod_pinner_replica = 1
castai_spot_handler_version = "0.21.0"
castai_pod_spot_handler_replica = 1
install_castai_security_agent = false
castai_kvisor_version = "1.0.45"
castai_workload_autoscaler_version = "0.1.43"
castai_pod_workload_autoscaler_replica = 1
node_templates-default_by_castai-is_default = true
node_templates-default_by_castai-is_enabled = true
node_configurations-default-disk_cpu_ratio = 25
node_configurations-default-max_pods_per_node = 150
node_templates-default_by_castai-constraints-on_demand = true
node_templates-default_by_castai-constraints-spot = true
node_templates-default_by_castai-constraints-use_spot_fallbacks = true
node_templates-default_by_castai-should_taint = false
node_templates-default_by-castai-constraints-enable_spot_diversity = false
node_templates-default_by-castai-constraints-spot_diversity_price_increase_limit_percent = 20
castai-node_downscaler-empty_nodes-delay_seconds = 300
castai-cluster_limits-cpu-minCores = 1
castai-cluster_limits-cpu-maxCores = 300
castai-node_downscaler-evictor-dry_run = true
castai-node_downscaler-evictor-scoped_mode = false
castai-node_downscaler-evictor-cycle_interval = "15s"
castai-node_downscaler-evictor-node_grace_period_minutes = 10
castai-autoscaler_settings-unschedulable_pods-enabled = true
castai-autoscaler_settings-cluster_limits-enabled = true
castai-autoscaler_settings-node_downscaler-enabled = false
castai-node_downscaler-empty_nodes-enabled = true
castai-autoscaler_settings-evictor-enabled = false
castai_rebalancing_schedule_id = "" # use API here to get UUID: https://docs.cast.ai/reference/scheduledrebalancingapi_listrebalancingschedules
castai_rebalancing_schedule_enabled = false 
  