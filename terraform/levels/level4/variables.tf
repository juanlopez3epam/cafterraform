variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  type        = any
  description = "Client configuration object (see module README.md)"
  default     = {}
}
variable "current_landingzone_key" {
  description = "Key for the current landing zones where the deployment is executed. Used in the context of landing zone deployment."
  default     = "local"
  type        = string
}
variable "logged_user_object_id" {
  description = "Used to set access policies based on the value 'logged_in_user'. Can only be used in interactive execution with vscode."
  type        = string
  default     = null
}
variable "logged_aad_app_object_id" {
  description = "Used to set access policies based on the value 'logged_in_aad_app'"
  type        = string
  default     = null
}
# variable "remote_state" {
#   description = "Remote state object (see module README.md)"
#   type = object({
#     resource_group_name  = string
#     storage_account_name = string
#     container_name       = string
#     key                  = optional(string, "state")
#   })
# }

variable "provider_azurerm_features_keyvault" {
  type        = any
  description = "Provider azurerm features keyvault"
  default = {
    purge_soft_delete_on_destroy = true
  }
}

variable "resource_groups" {
  type        = any
  description = "Resource groups"
  default     = {}
}

variable "subnets" {
  type        = any
  description = "Subnets"
  default     = {}
}

variable "aks_clusters" {
  description = "AKS cluster objects"
  type        = any
  default     = {}
}
variable "managed_identities" {
  description = "Managed Identity objects"
  type        = any
  default     = {}
}

variable "app_registrations" {
  description = "Service Principal Objects"
  type        = any
  default     = {}
}

variable "redis_caches" {
  description = "Redis Cache objects"
  type        = any
  default     = {}
}
variable "enterprise_redis_clusters" {
  description = "Enterprise Redis Cluster objects"
  type        = any
  default     = {}
}

variable "enterprise_redis_databases" {
  description = "Enterprise Redis Database objects"
  type        = any
  default     = {}
}

# variable "storage_accounts" {
#   description = "Storage Account objects"
#   type        = any
#   default     = {}
# }

variable "keyvaults" {
  description = "Key Vault objects"
  type        = any
  default     = {}
}
variable "keyvault_access_policies" {
  description = "Key Vault Access Policy objects"
  type        = any
  default     = {}
}
variable "keyvault_secrets" {
  description = "Key Vault Secret objects"
  type        = any
  default     = {}
}
variable "keyvault_keys" {
  description = "Key Vault Key objects"
  type        = any
  default     = {}
}
variable "dynamic_keyvault_secrets" {
  description = "Dynamic Key Vault Secret objects"
  type        = any
  default     = {}
}

variable "dynamic_object_secrets" {
  description = "Dynamic Key Vault Secret objects"
  type        = any
  default     = {}
}

variable "federated_identities" {
  description = "Federated Identity objects"
  type        = any
  default     = {}
}

variable "postgresql_flexible_servers" {
  description = "Postgresql Flexible Servers objects"
  type        = any
  default     = {}
}

variable "hdinsight_clusters" {
  description = "HDInsight cluster objects"
  type        = any
  default     = {}
}
variable "diagnostics_destinations" {
  description = "Diagnostics destinations"
  type        = any
  default     = {}
}

variable "diagnostics_definition" {
  description = "Diagnostics definitions"
  type        = any
  default     = {}
}

variable "mssql_servers" {
  description = "MSSQL Server objects"
  type        = any
  default     = {}
}
variable "mssql_databases" {
  description = "MSSQL Database objects"
  type        = any
  default     = {}
}
variable "elastic_cloud" {
  description = "Elastic Cloud objects"
  type        = any
  default     = {}
}
variable "elastic_cloud_deployments" {
  description = "Elastic Cloud deployment"
  type        = any
  default     = {}
}
variable "roles" {
  description = "Role objects"
  type        = any
  default     = {}
}
variable "route_tables" {
  description = "Route table objects"
  type        = any
  default     = {}
}
variable "routes" {
  description = "Route objects"
  type        = any
  default     = {}
}

# ==================================================================
# Diagnostics variables
# ==================================================================
variable "diagnostics_definition-redis_all-diagnostics_enabled" {
  description = "Redis diagnostics enabled"
  type        = bool
  default     = false
}
variable "diagnostics_definition-redis_all-retention_period" {
  description = "Redis diagnostics retention period"
  type        = number
  default     = 7
}

variable "diagnostics_definition-enterprise_redis_all-diagnostics_enabled" {
  description = "Redis enterprise diagnostics enabled"
  type        = bool
  default     = false
}

variable "diagnostics_definition-enterprise_redis_all-retention_period" {
  description = "Redis enterprise diagnostics retention period"
  type        = number
  default     = 7
}

variable "diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled" {
  description = "AKS diagnostics enabled"
  type        = bool
  default     = false
}

variable "diagnostics_definition-azure_kubernetes_cluster-retention_period" {
  description = "AKS diagnostics retention period"
  type        = number
  default     = 7
}

variable "diagnostics_definition-postgresql-diagnostics_enabled" {
  description = "postgresql diagnostics enabled"
  type        = bool
  default     = false
}

variable "diagnostics_definition-postgresql-retention_period" {
  description = "postgresql diagnostics retention period"
  type        = number
  default     = 7
}

variable "diagnostics_definition-keyvault-diagnostics_enabled" {
  description = "keyvault diagnostics enabled"
  type        = bool
  default     = false
}

variable "diagnostics_definition-keyvault-retention_period" {
  description = "keyvault diagnostics retention period"
  type        = number
  default     = 7
}

variable "diagnostics_definition-hd_insight-diagnostics_enabled" {
  description = "hd_insight diagnostics enabled"
  type        = bool
  default     = false
}

variable "diagnostics_definition-hd_insight-retention_period" {
  description = "hd_insight diagnostics retention period"
  type        = number
  default     = 7
}

variable "diagnostics_definition-azure_sql-diagnostics_enabled" {
  description = "azure_sql diagnostics enabled"
  type        = bool
  default     = false
}

variable "diagnostics_definition-azure_sql-retention_period" {
  description = "azure_sql diagnostics retention period"
  type        = number
  default     = 7
}

variable "eventhub_name" {
  description = "Eventhub Name"
  type        = string
  default     = null
}

variable "eventhub_authorization_rule_id" {
  description = "Eventhub Authorization Rule Id"
  type        = string
  default     = null
}

# ==================================================================
# TF Remote State variables
# ==================================================================
variable "remote_state-resource_group_name" {
  description = "Level3 remote tf state resource group name"
  type        = string
  default     = ""
}

variable "remote_state-storage_account_name" {
  description = "Level3 remote tf state storage account name"
  type        = string
  default     = ""
}
# ==================================================================
# Elastic Cloud variables
# ==================================================================
variable "elastic_cloud_deployments-elastic_cloud_cluster-name" {
  description = "Elastic Cloud Cluster Name"
  type        = string
  default     = ""
}
variable "elastic_cloud_deployments-elastic_cloud_cluster-region" {
  description = "Elastic Cloud Cluster region"
  type        = string
  default     = "azure-eastus"
}
variable "elastic_cloud_deployments-elastic_cloud_cluster-version" {
  description = "Elastic Cloud Cluster version"
  type        = string
  default     = "7.17.0"
}
variable "elastic_cloud_deployments-elastic_cloud_cluster-deployment_template_id" {
  description = "Elastic Cloud Cluster deployment template id"
  type        = string
  default     = "azure-general-purpose"
}

variable "elastic_cloud_deployments-elastic_cloud_cluster-size_per_zone" {
  description = "Elastic Cloud Cluster Size Per Zone"
  type        = string
  default     = "8g"
}
######
variable "elastic_cloud_deployments-runner_pvt_endpoint_subnet_name" {
  description = "Confluent Cloud Kafka Cluster runner subnet"
  type        = string
  default     = "confluentkafkapvtendpointsubnet"
}
variable "elastic_cloud_deployments-runner_subscription_id" {
  description = "Subscription id where Runner running confluent kafka is located"
  type        = string
  default     = "c49ee34f-de27-4fe2-8a75-0c7cd031ea6e"
}
variable "elastic_cloud_deployments-runner_resource_group" {
  description = "Resource group where Runner running confluent kafka is located"
  type        = string
  default     = "Github-Action-Runner-SaaS-MICloud"
}
variable "elastic_cloud_deployments-runner_region" {
  description = "Region where Runner running confluent kafka is located"
  type        = string
  default     = "eastus" #should be same as kafka cluster region for privatelink to work as of now
}
variable "elastic_cloud_deployments-runner_vnet" {
  description = "Region where Runner running confluent kafka is located"
  type        = string
  default     = "runner-vnet"
}
variable "elastic_cloud_deployments-runner_create_private_network" {
  description = "Private Network for GitHub Runner should be created"
  type        = string
  default     = "runner-vnet"
}
# ==================================================================
# Postgres variables
# ==================================================================

variable "postgresql_flexible_servers-backup_retention_days"{
  description = "Backup retention days"
  type        = string
  default     = "7"
}
variable "postgresql_flexible_servers-geo_redundant_backup_enabled"{
  description = "Geo redundant backup enabled"
  type        = bool
  default     = false
}
variable "postgresql_flexible_servers-auriga-version" {
  description = "Auriga Postgres version"
  type        = string
  default     = "13"
}
variable "postgresql_flexible_servers-auriga-sku_name" {
  description = "Auriga Postgres SKU name"
  type        = string
  default     = "GP_Standard_D2ds_v4"
}
variable "postgresql_flexible_servers-auriga-storage_mb" {
  description = "Auriga Postgres Storage (MB)"
  type        = number
  default     = 131072
}

variable "postgresql_flexible_servers-public_network_access_enabled" {
  description = "Public network access for servers"
  type        = bool
  default     = false
}

variable "postgresql_flexible_servers-auriga-zone" {
  description = "Auriga Postgres zone"
  type        = string
  default     = "1"
}

variable "postgresql_flexible_servers-sample-version" {
  description = "sample Postgres version"
  type        = string
  default     = "13"
}
variable "postgresql_flexible_servers-sample-sku_name" {
  description = "sample Postgres SKU name"
  type        = string
  default     = "GP_Standard_D16ds_v4"
}
variable "postgresql_flexible_servers-sample-storage_mb" {
  description = "sample Postgres Storage (MB)"
  type        = number
  default     = 131072
}
variable "postgresql_flexible_servers-sample-zone" {
  description = "sample Postgres zone"
  type        = string
  default     = "2"
}
variable "postgresql_flexible_servers-sample_async_replica-zone" {
  description = "sample Postgres replica 1 zone"
  type        = string
  default     = "3"
}
variable "postgresql_flexible_servers-sample_sync_replica-zone" {
  description = "sample Postgres replica 2 zone"
  type        = string
  default     = "1"
}
variable "postgresql_flexible_servers-sample_sync_replica_ha-zone" {
  description = "sample Postgres replica 3 zone"
  type        = string
  default     = "2"
}
variable "create-postgresql_flexible_servers-sample_sync_replica" {
  description = "Create sample Postgres read replica 2"
  type        = bool
  default     = false
}
variable "create-postgresql_flexible_servers-sample_sync_replica_ha" {
  description = "Create sample Postgres read replica 3"
  type        = bool
  default     = false
}
variable "postgresql_flexible_servers-sample-maintenance_work_mem" {
  description = "sample Postgres Maintenance Work Memory (MB)"
  type        = number
  default     = 131071
}
variable "postgresql_flexible_servers-sample-shared_buffers" {
  description = "sample Postgres shared buffers"
  type        = string
  default     = "3355443"
}
variable "postgresql_flexible_servers-sample-effective_cache_size" {
  description = "sample Postgres effective cache size"
  type        = string
  default     = "4194304"
}

variable "postgresql-jasper-version" {
  description = "Jasper Postgres version"
  type        = string
  default     = "13"
}

variable "postgresql-jasper-sku_name" {
  description = "Jasper Postgres SKU name"
  type        = string
  default     = "GP_Standard_D4ds_v4"
}

variable "postgresql-jasper-storage_mb" {
  description = "Jasper Postgres Storage (MB)"
  type        = number
  default     = 131072
}

variable "postgresql-jasper-zone" {
  description = "Jasper Postgres zone"
  type        = string
  default     = "3"
}

variable "postgresql-kong-version" {
  description = "Kong Postgres version"
  type        = string
  default     = "13"
}

variable "postgresql-kong-sku_name" {
  description = "Kong Postgres SKU name"
  type        = string
  default     = "GP_Standard_D2ds_v4"
}

variable "postgresql-kong-storage_mb" {
  description = "Kong Postgres Storage (MB)"
  type        = number
  default     = 131072
}

variable "postgresql-kong-zone" {
  description = "Kong Postgres zone"
  type        = string
  default     = "2"
}

variable "postgresql-aquila-version" {
  description = "Aquila Postgres version"
  type        = string
  default     = "13"
}

variable "postgresql-aquila-sku_name" {
  description = "Aquila Postgres SKU name"
  type        = string
  default     = "GP_Standard_D2ds_v4"
}

variable "postgresql-aquila-storage_mb" {
  description = "Aquila Postgres Storage (MB)"
  type        = number
  default     = 131072
}

variable "postgresql-aquila-zone" {
  description = "Aquila Postgres zone"
  type        = string
  default     = "1"
}

variable "postgresql-vault2-version" {
  description = "Vault2 Postgres version"
  type        = string
  default     = "13"
}

variable "postgresql-vault2-sku_name" {
  description = "Vault2 Postgres SKU name"
  type        = string
  default     = "GP_Standard_D2ds_v4"
}

variable "postgresql-vault2-storage_mb" {
  description = "Vault2 Postgres Storage (MB)"
  type        = number
  default     = 131072
}

variable "postgresql-vault2-zone" {
  description = "Vault2 Postgres zone"
  type        = string
  default     = "2"
}

variable "postgresql_flexible_servers-auriga-high_availability-enabled" {
  description = "Set to true to enable HA for postgresql servers"
  type        = bool
  default     = false
}
variable "postgresql_flexible_servers-sample-high_availability-enabled" {
  description = "Set to true to enable HA for postgresql servers"
  type        = bool
  default     = false
}
variable "postgresql_flexible_servers-jasper-high_availability-enabled" {
  description = "Set to true to enable HA for postgresql servers"
  type        = bool
  default     = false
}
variable "postgresql_flexible_servers-kong-high_availability-enabled" {
  description = "Set to true to enable HA for postgresql servers"
  type        = bool
  default     = false
}
variable "postgresql_flexible_servers-aquila-high_availability-enabled" {
  description = "Set to true to enable HA for postgresql servers"
  type        = bool
  default     = false
}
variable "postgresql_flexible_servers-vault2-high_availability-enabled" {
  description = "Set to true to enable HA for postgresql servers"
  type        = bool
  default     = false
}

# ==================================================================
# AKS variables
# ==================================================================

variable "aks_clusters-cluster_re1-kubernetes_version" {
  description = "AKS k8s version"
  type        = string
  default     = ""
}

variable "aks_clusters-cluster_re1-default_node_pool-vm_size" {
  description = "AKS cluster VM size"
  type        = string
  default     = "Standard_D4ds_v4"
}

variable "aks_clusters-cluster_re1-pool1-vm_size" {
  description = "AKS cluster VM size"
  type        = string
  default     = "Standard_D8ds_v4"
}

variable "aks_clusters-cluster_re1-default_node_pool-enable_auto_scaling" {
  description = "Enable default AKS cluster default nodepool autoscailing"
  type        = bool
  default     = true
}

variable "aks_clusters-cluster_re1-default_node_pool-min_count" {
  description = "AKS cluster nodepool min count"
  type        = number
  default     = 1
}

variable "aks_clusters-cluster_re1-default_node_pool-max_count" {
  description = "AKS cluster nodepool max count"
  type        = number
  default     = 3
}

variable "aks_clusters-cluster_re1-default_node_pool-os_disk_size_gb" {
  description = "AKS cluster default nodepool disk size (GB)"
  type        = number
  default     = 150
}

variable "aks_clusters-cluster_re1-pool1-enable_auto_scaling" {
  description = "Enable default AKS cluster nodepool 1 autoscailing"
  type        = bool
  default     = true
}

variable "aks_clusters-cluster_re1-pool1-min_count" {
  description = "AKS cluster nodepool min count"
  type        = number
  default     = 7
}

variable "aks_clusters-cluster_re1-pool1-max_count" {
  description = "AKS cluster nodepool max count"
  type        = number
  default     = 12
}

variable "aks_clusters-cluster_re1-pool1-os_disk_size_gb" {
  description = "AKS cluster workerpool1 nodepool disk size (GB)"
  type        = number
  default     = 150
}

variable "aks_clusters-cluster_re1-default_node_pool-availability_zones" {
  description = "AKS cluster systempool nodepool availability_zones"
  type        = list(any)
  default = [1, 2, 3]
}

variable "aks_clusters-cluster_re1-pool1-availability_zones" {
  description = "AKS cluster workerpool1 nodepool availability_zones"
  type        = list(any)
  default = [1, 2, 3]
}

variable "aks_clusters-cluster_re1-node_os_upgrader_option" {
  description = "AKS cluster node os upgrader option"
  type        = string
  default     = ""
}

variable "keyvault-aad_group-object_id" {
  description = "Keyvault AAD Object ID"
  type        = string
  default     = ""
}

variable "postgres-aad_group-object_id" {
  description = "Keyvault AAD Object ID"
  type        = string
  default     = ""
}

variable "rbac-aad_group-object_id" {
  description = "RBAC AAD Object ID"
  type        = list(any)
  default     = []
}

variable "rbac-external_resources-acr" {
  description = "Build ACR endpoint"
  type        = string
  default     = ""
}

variable "storage_accounts-dbmanager_storage-name" {
  description = "StorageBlob endpoint"
  type        = string
  default     = ""
}
# ==================================================================
# Redis variables
# ==================================================================
variable "enterprise_redis_clusters-sample_primary-sku_name" {
  description = "sample primary Redis sku_name"
  type        = string
  default     = ""
}
variable "enterprise_redis_clusters-sample_primary-minimum_tls_version" {
  description = "sample primary Redis min TLS version"
  type        = string
  default     = "1.2"
}
variable "enterprise_redis_clusters-sample_primary-redis_version" {
  description = "sample primary Redis version"
  type        = string
  default     = "6.2"
}
variable "sample_device_checkin-sku_name" {
  description = "sample device checkin sku_name"
  type        = string
  default     = ""
}
variable "sample_device_checkin-redis_version" {
  description = "sample sample_device_checkin Redis version"
  type        = string
  default     = "6.2"
}
variable "sample_rate_limit-sku_name" {
  description = "sample device checkin sku_name"
  type        = string
  default     = ""
}
variable "sample_rate_limit-redis_version" {
  description = "sample sample_device_checkin Redis version"
  type        = string
  default     = "6.2"
}
variable "create-separate-sample_rate_limiting-cache" {
  description = "Set to true to create a separate sample rate limiting redis cache"
  type        = bool
  default     = true
}
variable "create-separate-sample_device_checkin-cache" {
  description = "Set to true to create a separate sample device checkin redis cache"
  type        = bool
  default     = false
}
variable "create-separate-sample_rate_limit-cache" {
  description = "Set to true to create a separate sample rate limit redis cache"
  type        = bool
  default     = false
}
variable "sample_device_checkin-minimum_tls_version" {
  description = "sample sample_device_checkin min TLS version"
  type        = string
  default     = ""
}
variable "sample_rate_limit-minimum_tls_version" {
  description = "sample sample_rate_limit min TLS version"
  type        = string
  default     = ""
}

# ==================================================================
# HDInsight variables
# ==================================================================
variable "hdinsight_clusters-primary-tags-privatedns" {
  description = "HDInsight privatedns"
  type        = string
  default     = ""
}
variable "hdinsight_clusters-primary-roles-head_node-vm_size" {
  description = "HDInsight head node VM Size"
  type        = string
  default     = ""
}
variable "hdinsight_clusters-primary-roles-worker_node-vm_size" {
  description = "HDInsight worker node VM Size"
  type        = string
  default     = ""
}
variable "hdinsight_clusters-primary-roles-worker-number_of_disks_per_node" {
  description = "HDInsight worker node no of disks per node"
  type        = number
  default     = 2
}
variable "hdinsight_clusters-primary-roles-worker-target_instance_count" {
  description = "HDInsight worker node target instance count"
  type        = number
  default     = 4
}
variable "hdinsight_clusters-primary-roles-zookeeper_node-vm_size" {
  description = "HDInsight zookeeper node VM Size"
  type        = string
  default     = ""
}
variable "hdinsight_clusters-primary-cluster_version" {
  description = "HDInsight cluster version"
  type        = string
  default     = "5.0"
}
variable "hdinsight_clusters-primary-cluster_component_version" {
  description = "HDInsight cluster component version"
  type        = string
  default     = "2.4"
}

# ==================================================================
# Routes
# ==================================================================
variable "routes-hd_insights_health_1-name" {
  description = "HDInsight route health1 name"
  type        = string
  default     = "168.61.49.99"
}
variable "routes-hd_insights_health_2-name" {
  description = "HDInsight route health2 name"
  type        = string
  default     = "23.99.5.239"
}
variable "routes-hd_insights_health_3-name" {
  description = "HDInsight route health3 name"
  type        = string
  default     = "168.61.48.131"
}
variable "routes-hd_insights_health_4-name" {
  description = "HDInsight route health4 name"
  type        = string
  default     = "138.91.141.162"
}
variable "routes-hd_insights_health_regional_1-name" {
  description = "HDInsight route health regional1 name"
  type        = string
  default     = "13.82.225.233"
}
variable "routes-hd_insights_health_regional_2-name" {
  description = "HDInsight route health regional2 name"
  type        = string
  default     = "40.71.175.99"
}

# ==================================================================
# Subnet
# ==================================================================
variable "subnets-pvt-cidr" {
  description = "Private endpoint subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.0/25"]
}
variable "subnets-pg_pol-cidr" {
  description = "sample Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.128/28"]
}
variable "subnets-pg_pol_replica-cidr" {
  description = "sample Postgres replica subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.144/28"]
}
variable "subnets-pg_jasper-cidr" {
  description = "Jasper Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.160/28"]
}
variable "subnets-pg_aquila-cidr" {
  description = "Aquila Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.176/28"]
}
variable "subnets-pg_auriga-cidr" {
  description = "Auriga Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.192/28"]
}
variable "subnets-pg_pol_replica2-cidr" {
  description = "sample Postgres replica 2 subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.240/28"]
}
variable "subnets-pg_pol_replica3-cidr" {
  description = "sample Postgres replica 3 subnet CIDR"
  type        = list(any)
  default     = ["10.22.1.0/28"]
}
variable "subnets-pg_kong-cidr" {
  description = "Kong Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.208/28"]
}

variable "subnets-pg_vault2-cidr" {
  description = "Vault2 Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.0.224/28"]
}

variable "subnets-aks_ingress_services-cidr" {
  description = "aks_ingress_services Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.2.0/24"]
}

variable "subnets-aks_system-cidr" {
  description = "aks_system Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.4.0/23"]
}

variable "subnets-aks_pool_1-cidr" {
  description = "aks_pool_1 Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.64.0/18"]
}

variable "subnets-hdinsights-cidr" {
  description = "hdinsights Postgres subnet CIDR"
  type        = list(any)
  default     = ["10.22.128.0/27"]
}

variable "subnets-kafka-pvt-cidr" {
  description = "hdinsights private endpoint subnet CIDR"
  type        = list(any)
  default     = ["10.22.128.32/27"]
}

# ==================================================================
# MSSQL variables
# ==================================================================

variable "mssql_servers-hdinsight_metastore-location" {
  description = "Mssql hdinsight metastore location"
  type        = string
  default     = "eastus"
}

variable "mssql_servers-hdinsight_metastore-version" {
  description = "Mssql hdinsight metastore version"
  type        = string
  default     = "12.0"
}

variable "mssql_servers-hdinsight_metastore-azuread_administrator-object_id" {
  description = "Mssql hdinsight metastore azuread object id"
  type        = string
  default     = ""
}

# ==================================================================
# Confluent Cloud variables
# ==================================================================
variable "confluent_cloud_deployments-kafka_cluster-display_name" {
  description = "Confluent Cloud Kafka Cluster deployment name"
  type        = string
  default     = "basic_kafka_dap_dev_1"
}
variable "confluent_cloud_deployments-kafka_cluster-availability" {
  description = "Confluent Cloud Kafka Cluster deployment availability"
  type        = string
  default     = "SINGLE_ZONE"
}
variable "confluent_cloud_deployments-kafka_cluster-cloud" {
  description = "Confluent Cloud Kafka Cluster deployment cloud type"
  type        = string
  default     = "AZURE"
}
variable "confluent_cloud_deployments-kafka_cluster-region" {
  description = "Confluent Cloud Kafka Cluster deployment region"
  type        = string
  default     = "eastus"
}
variable "confluent_cloud_deployments-kafka_cluster-env_display_name" {
  description = "Confluent Cloud environment name"
  type        = string
  default     = "fordteam-1"
}
variable "confluent_cloud_deployments-kafka_cluster-cku" {
  description = "Confluent Cloud Kafka Cluster deployment cku"
  type        = number
  default     = 1
}
variable "confluent_cloud_deployments-runner_pvt_endpoint_subnet_name" {
  description = "Confluent Cloud Kafka Cluster runner subnet"
  type        = string
  default     = "confluentkafkapvtendpointsubnet"
}
variable "confluent_cloud_deployments-runner_subscription_id" {
  description = "Subscription id where Runner running confluent kafka is located"
  type        = string
  default     = "c49ee34f-de27-4fe2-8a75-0c7cd031ea6e"
}
variable "confluent_cloud_deployments-runner_resource_group" {
  description = "Resource group where Runner running confluent kafka is located"
  type        = string
  default     = "Github-Action-Runner-SaaS-MICloud"
}
variable "confluent_cloud_deployments-runner_region" {
  description = "Region where Runner running confluent kafka is located"
  type        = string
  default     = "eastus" #should be same as kafka cluster region for privatelink to work as of now
}
variable "confluent_cloud_deployments-runner_vnet" {
  description = "Region where Runner running confluent kafka is located"
  type        = string
  default     = "runner-vnet"
}
variable "aks_clusters-cluster_re1-outbound_ip_prefix_ids" {
    description = "List of Public IP Address IDs to use for outbound traffic"
    type        = list(string)
    default     = []
}

variable "aks_clusters-cluster_re1-api_server_authorized_ip_ranges" {
  description = "K8s API server authorized CIDR"
  type        = list(string)
  default     = ["202.54.198.105/32,202.54.141.6/32,202.54.141.4/32,202.54.200.105/32,185.115.118.4/32,67.199.253.6/32,49.37.226.225/32"]
}

variable "aks_clusters-cluster_re1-sku_tier" {
  description = "K8s sku tier(Free,Standard,Premium)"
  type        = string
  default     = "Free"
}

variable "network_restrictions_ip_rule_list" {
  description = "List of IP rules for network restrictions"
  type        = list(string)
  default     = []
}

variable "storage_accounts-crl_repplication_type" {
  description = "Replication Type for Aquila CRL Storage Account"
  type        = string
  default     = "LRS"
}

variable "cdn-crl_sku" {
  description = "SKU Type for Aquila CRL CDN"
  type        = string
  default     = "Standard_Microsoft"
}

variable "create-public_ip_address-kong-lb" {
  description = "Create Role for Kong Public LB IP Address"
  type        = bool
  default     = false
}

##########################################################################################
# Variables for CastAI
##########################################################################################
variable "castai_enabled" {
  description = "Enable Cast AI"
  type        = bool
  default     = true
}
variable "cast_ai_read_only" {
  description = "Enable Cast AI read only mode"
  type        = bool
  default     = false
}
variable "castai_api_token" {
  description = "CastAI API Token (Key)"
  type        = string
  default     = ""
  sensitive   = true
}
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = ""
}
variable "additional_resource_groups" {
  description = "Additional Resoure Group IDs to provide for castai role assignment"
  type        = list(string)
  default     = []
}
variable "deployment_sp_id" {
  description = "Client ID of deployment Service pricipal"
  type        = string
  default     = ""
}
variable "deployment_sp_password" {
  description = "Secret/password of deployment Service pricipal"
  type        = string
  default     = ""
  sensitive   = true
}
variable "castai_sp_id" {
  description = "Service Principle ID for CastAI (ObjectID of Entrprise Application (castai-{env}-tf))"
  type        = string
  default     = ""
}
variable "castai_app_clinet_id" {
  description = "Client ID of Azure AD castai Application"
  type        = string
  default     = ""
}
variable "castai_app_client_secret" {
  description = "Password (Secret) for castai Application"
  type        = string
  sensitive   = true
  default     = ""
}
variable "delete_nodes_on_disconnect" {
  type        = bool
  description = "Optionally delete Cast AI created nodes when the cluster is destroyed"
  default     = false
}
variable "castai_autoscaler_policies_enabled" {
  type    = bool
  default = true
}
variable "node_templates_partial_matching_enabled" {
  type    = bool
  default = false
}
variable "castai_api_url" {
  type        = string
  description = "URL of alternative CAST AI API to be used during development or testing"
  default     = "https://api.cast.ai"
}
variable "castai_agent_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.79.0"
}
variable "castai_agent_replica" {
  description = "ReplicaCount for CastAi agent pods"
  type        = number
  default     = 2
}
variable "castai_cluster_controller_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.67.0"
}
variable "castai_cluster_controller_replica" {
  description = "ReplicaCount for CastAi cluster-controller pods"
  type        = number
  default     = 2
}
variable "castai_evictor_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.30.18"
}
variable "castai_evictor_replica" {
  description = "ReplicaCount for CastAi Evictor pods"
  type        = number
  default     = 1
}
variable "evictor_aggresive_mode_enabled" {
  description = "When activated, Evictor will also consider applications with only a single replica. It is important to note that this mode is not advised for use in production clusters."
  type        = bool
  default     = false
}
variable "castai_evictor_ext_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.1.0"
}
variable "castai_pod_pinner_version" {
  description = "Version of pod-pinner helm chart."
  type        = string
  default     = "0.6.0"
}
variable "castai_pod_pinner_replica" {
  description = "Pod Pinner Replica Count"
  type        = number
  default     = 1
}
variable "castai_spot_handler_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.21.0"
}
variable "castai_pod_spot_handler_replica" {
  description = "Number of replicas for the castai-spot-handler"
  type        = number
  default     = 1
}
variable "install_castai_security_agent" {
  description = "Optional flag for installation of security agent (https://docs.cast.ai/product-overview/console/security-insights/)"
  type        = bool
  default     = false
}
variable "castai_kvisor_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "1.0.45"
}
variable "castai_workload_autoscaler_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.1.43"
}
variable "castai_pod_workload_autoscaler_replica" {
  description = "Number of replicas for the castai-workload-autoscaler"
  type        = number
  default     = 1
}
variable "node_templates-default_by_castai-is_default" {
  description = "Is Default by cast is default node template"
  type        = bool
  default     = true
}
variable "node_templates-default_by_castai-is_enabled" {
  description = "Is Default by cast is default node template enabled"
  type        = bool
  default     = true
}
variable "node_configurations-default-disk_cpu_ratio" {
  description = "Default disk cpu ratio"
  type        = number
  default     = 25
}
variable "node_configurations-default-max_pods_per_node" {
  description = "Default max pods per node"
  type        = number
  default     = 150
}
variable "node_templates-default_by_castai-constraints-on_demand" {
  description = "Default by castai constraints on demand"
  type        = bool
  default     = true
}
variable "node_templates-default_by_castai-constraints-spot" {
  description = "Default by castai constraints spot"
  type        = bool
  default     = true
}
variable "node_templates-default_by_castai-constraints-use_spot_fallbacks" {
  description = "Default by castai constraints use spot fallbacks"
  type        = bool
  default     = true  
}
variable "node_templates-default_by_castai-should_taint" {
  description = "Default by castai should taint"
  type        = bool
  default     = false
}
variable "node_templates-default_by-castai-constraints-enable_spot_diversity" {
  description = "Default by castai constraints enable spot diversity"
  type        = bool
  default     = false
}
variable "node_templates-default_by-castai-constraints-spot_diversity_price_increase_limit_percent" {
  description = "Default by castai constraints spot diversity price increase limit percentage"
  type        = number
  default     = 20
}
variable "castai-node_downscaler-empty_nodes-delay_seconds" {
  description = "Delay in seconds before downscaling empty nodes"
  type        = number
  default     = 2
}
variable "castai-cluster_limits-cpu-minCores" {
  description = "Minimum CPU cores"
  type        = number
  default     = 1
}
variable "castai-cluster_limits-cpu-maxCores" {
  description = "Maximum CPU cores"
  type        = number
  default     = 500
}
variable "castai-node_downscaler-evictor-dry_run" {
  description = "Evictor dry run"
  type        = bool
  default     = false
}
variable "castai-node_downscaler-evictor-scoped_mode" {
  description = "Evictor scoped mode"
  type        = bool
  default     = false
}
variable "castai-node_downscaler-evictor-cycle_interval" {
  description = "Evictor cycle interval seconds"
  type        = string
  default     = "5s"
}
variable "castai-node_downscaler-evictor-node_grace_period_minutes" {
  description = "Evictor node grace period minutes"
  type        = number
  default     = 5
}
variable "castai-autoscaler_settings-unschedulable_pods-enabled" {
  description = "Enable unschedulable pods"
  type        = bool
  default     = true
}
variable "castai-autoscaler_settings-cluster_limits-enabled" {
  description = "Enable cluster autoscaler limits"
  type        = bool
  default     = true
}
variable "castai-autoscaler_settings-node_downscaler-enabled" {
  description = "Enable node downscaler"
  type        = bool
  default     = true
}
variable "castai-node_downscaler-empty_nodes-enabled" {
  description = "Enable empty nodes downscaler"
  type        = bool
  default     = true
}
variable "castai-autoscaler_settings-evictor-enabled" {
  description = "Enable evictor"
  type        = bool
  default     = true
}
variable "castai_rebalancing_schedule_id" {
  type        = string
  description = "CAST AI rebalancing schedule ID"
  default     = "268b7e08-368b-4e5a-8959-7126758a7e1d"  # use API here to get UUID: https://docs.cast.ai/reference/scheduledrebalancingapi_listrebalancingschedules
}
variable "castai_rebalancing_schedule_enabled" {
  description = "Enable CAST AI rebalancing schedule"
  type        = bool
  default     = true
}
