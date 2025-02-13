module "castai" {
  source = "../../modules/cast_ai"
  count  = var.castai_enabled  ? 1 : 0
  depends_on = [
    module.aks,
    module.subnets
  ]
  providers = {
    azurerm = azurerm
    castai  = castai
  }
  global_settings                     = var.global_settings
  client_config                       = var.client_config
  deployment_sp_id                    = var.deployment_sp_id
  deployment_sp_password              = var.deployment_sp_password
  aks_cluster_name                    = module.aks["cluster_re1"].cluster_name
  aks_cluster_region                  = var.global_settings.regions.region1
  subscription_id                     = var.global_settings.default_subscription_id
  rg_name                             = module.aks["cluster_re1"].resource_group_name
  aks_node_rg                         = module.aks["cluster_re1"].node_resource_group
  additional_resource_groups          = [ local.consolidated_objects_resource_groups["local"]["vnet-01"].id ] 
  aad_tenant_id                       = data.azurerm_client_config.current.tenant_id
  cast_ai_read_only                   = var.cast_ai_read_only
  cast_ai_enabled                     = var.castai_enabled
  castai_sp_id                        = var.castai_sp_id
  castai_app_clinet_id                = var.castai_app_clinet_id
  castai_app_client_secret            = var.castai_app_client_secret
  castai_api_token                    = var.castai_api_token
  delete_nodes_on_disconnect          = var.delete_nodes_on_disconnect
  castai_rebalancing_schedule_id      = var.castai_rebalancing_schedule_id
  castai_rebalancing_schedule_enabled = var.castai_rebalancing_schedule_enabled
  node_configurations                 = !var.cast_ai_read_only ? {
    default = {
      disk_cpu_ratio    = var.node_configurations-default-disk_cpu_ratio
      max_pods_per_node = var.node_configurations-default-max_pods_per_node
      subnets = [
        local.virtual_networks["vnet-01"].subnets["aks_pool_1"].id
      ]
    }
  } : {}
  default_node_configuration =  module.castai[0].castai_node_configurations["default"]
  node_templates = {  
    default_by_castai = {
      name             = "default-by-castai"
      configuration_id = module.castai[0].castai_node_configurations["default"]
      is_default       = var.node_templates-default_by_castai-is_default
      is_enabled       = var.node_templates-default_by_castai-is_enabled
      should_taint     = var.node_templates-default_by_castai-should_taint

      constraints = {
        on_demand           = var.node_templates-default_by_castai-constraints-on_demand
        spot                = var.node_templates-default_by_castai-constraints-spot
        use_spot_fallbacks  = var.node_templates-default_by_castai-constraints-use_spot_fallbacks

        enable_spot_diversity                         = var.node_templates-default_by-castai-constraints-enable_spot_diversity
        spot_diversity_price_increase_limit_percent   = var.node_templates-default_by-castai-constraints-spot_diversity_price_increase_limit_percent
      }
    }
  }
  autoscaler_settings = {
    enabled                                   = var.castai_autoscaler_policies_enabled
    node_templates_partial_matching_enabled   = var.node_templates_partial_matching_enabled
    unschedulable_pods = {
      enabled = var.castai-autoscaler_settings-unschedulable_pods-enabled
    }
    cluster_limits = {
      enabled = var.castai-autoscaler_settings-cluster_limits-enabled
      cpu = {
        min_cores : var.castai-cluster_limits-cpu-minCores
        max_cores : var.castai-cluster_limits-cpu-maxCores
      }
    }
    node_downscaler = {
      enabled = var.castai-autoscaler_settings-node_downscaler-enabled
      empty_nodes = {
        enabled       = var.castai-node_downscaler-empty_nodes-enabled
        delay_seconds = var.castai-node_downscaler-empty_nodes-delay_seconds
      }
      evictor = {
        enabled                   = var.castai-autoscaler_settings-evictor-enabled
        dry_run                   = var.castai-node_downscaler-evictor-dry_run
        aggressive_mode           = var.evictor_aggresive_mode_enabled
        scoped_mode               = var.castai-node_downscaler-evictor-scoped_mode
        cycle_interval            = var.castai-node_downscaler-evictor-cycle_interval
        node_grace_period_minutes = var.castai-node_downscaler-evictor-node_grace_period_minutes
      }
    }
  }
  castai_agent_version                    = var.castai_agent_version
  castai_agent_replica                    = var.castai_agent_replica
  castai_cluster_controller_version       = var.castai_cluster_controller_version
  castai_evictor_version                  = var.castai_evictor_version
  castai_evictor_ext_version              = var.castai_evictor_ext_version
  castai_pod_pinner_version               = var.castai_pod_pinner_version
  castai_pod_pinner_replica               = var.castai_pod_pinner_replica
  castai_spot_handler_version             = var.castai_spot_handler_version
  castai_pod_spot_handler_replica         = var.castai_pod_spot_handler_replica
  install_castai_security_agent           = var.install_castai_security_agent
  castai_kvisor_version                   = var.castai_kvisor_version
  castai_workload_autoscaler_version      = var.castai_workload_autoscaler_version
  castai_pod_workload_autoscaler_replica  = var.castai_pod_workload_autoscaler_replica
  castai_cluster_controller_replica       = var.castai_cluster_controller_replica 
}
