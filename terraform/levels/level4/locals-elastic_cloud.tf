locals {
  
  elastic_cloud = {}
  pe_dns_zone_key = "privatelink.${var.global_settings.loc_code}.azure.elastic-cloud.com"
  elastic_cloud_deployments = {
    elastic_cloud_cluster = {
      name                   = var.elastic_cloud_deployments-elastic_cloud_cluster-name
      region                 = var.elastic_cloud_deployments-elastic_cloud_cluster-region
      version                = var.elastic_cloud_deployments-elastic_cloud_cluster-version
      deployment_template_id = var.elastic_cloud_deployments-elastic_cloud_cluster-deployment_template_id
      resource_group_key     = "security_re1"

      elasticsearch = {
        hot = {
          size = var.elastic_cloud_deployments-elastic_cloud_cluster-size_per_zone
          autoscaling = {}
        }
      }
      private_endpoint = {
        name = "elastic-cloud"
        subnet = {
          subnet_key = "pvt"
        }
        private_service_connection = {
          is_manual_connection = true
          request_message      = "Azure Private Link"
        }
        private_dns = {
          pe = {
            dns_zone_key = local.pe_dns_zone_key
            lz_key       = "core_lvl2"
          }
        }
      }
      private_dns_zone_rg  = local.consolidated_objects_private_dns_zones["core_lvl2"][local.pe_dns_zone_key].resource_group_name
      base_vnet_id         = local.consolidated_objects_networking["local"]["vnet-01"].id
    } 
  }
  elastic_cloud_deployments_runner_settings = {
    region                   = var.elastic_cloud_deployments-runner_region
    resource_group           = var.elastic_cloud_deployments-runner_resource_group
    vnet                     = var.elastic_cloud_deployments-runner_vnet
    subscription_id          = var.elastic_cloud_deployments-runner_subscription_id
    pvt_endpoint_subnet_name = var.elastic_cloud_deployments-runner_pvt_endpoint_subnet_name
    create_runner_pe         = var.elastic_cloud_deployments-runner_create_private_network
  }
}
