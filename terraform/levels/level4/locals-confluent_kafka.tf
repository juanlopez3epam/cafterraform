locals {
  confluent_cloud_deployments_cluster_settings = {
    kafka_cluster = {
      env_display_name     = var.confluent_cloud_deployments-kafka_cluster-env_display_name
      display_name         = var.confluent_cloud_deployments-kafka_cluster-display_name
      availability         = var.confluent_cloud_deployments-kafka_cluster-availability
      cloud                = var.confluent_cloud_deployments-kafka_cluster-cloud
      region               = var.confluent_cloud_deployments-kafka_cluster-region
      cku                  = var.confluent_cloud_deployments-kafka_cluster-cku
      keyvault_key         = "kafka"
      vnet_key             = "confluent"
      vnet_subnet_key      = "kafka_pvt"
      is_multizone_cluster = var.confluent_cloud_deployments-kafka_cluster-availability == "MULTI_ZONE" ? true : false
    }
  }

    confluent_cloud_deployments_runner_settings = {
      region                   = var.confluent_cloud_deployments-runner_region
      resource_group           = var.confluent_cloud_deployments-runner_resource_group
      vnet                     = var.confluent_cloud_deployments-runner_vnet
      subscription_id          = var.confluent_cloud_deployments-runner_subscription_id
      pvt_endpoint_subnet_name = var.confluent_cloud_deployments-runner_pvt_endpoint_subnet_name
  }
}