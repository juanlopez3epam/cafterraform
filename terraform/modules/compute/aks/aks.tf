resource "azurecaf_name" "aks" {
  name          = var.name
  resource_type = "azurerm_kubernetes_cluster"
  prefixes      = try(var.settings.naming_convention.cluster_name.prefixes, try(var.global_settings.prefixes, null))
  suffixes      = try(var.settings.naming_convention.cluster_name.suffixes, try(var.global_settings.suffixes, null))
  random_length = try(var.settings.naming_convention.cluster_name.random_length, try(var.global_settings.random_length, null))
  clean_input   = true
  passthrough   = try(var.settings.naming_convention.cluster_name.passthrough, try(var.global_settings.passthrough, null))
  use_slug      = try(var.settings.naming_convention.cluster_name.use_slug, try(var.global_settings.use_slug, null))
}

resource "azurecaf_name" "default_node_pool" {
  name          = var.settings.default_node_pool.name
  resource_type = "aks_node_pool_linux"
  prefixes      = try(var.settings.naming_convention.default_node_pool.prefixes, try(var.global_settings.prefixes, null))
  suffixes      = try(var.settings.naming_convention.default_node_pool.suffixes, try(var.global_settings.suffixes, null))
  random_length = try(var.settings.naming_convention.default_node_pool.random_length, try(var.global_settings.random_length, null))
  clean_input   = true
  passthrough   = try(var.settings.naming_convention.default_node_pool.passthrough, try(var.global_settings.passthrough, null))
  use_slug      = try(var.settings.naming_convention.default_node_pool.use_slug, try(var.global_settings.use_slug, null))
}


resource "azurecaf_name" "rg_node" {
  count = try(var.settings.node_resource_group_name, null) == null ? 0 : 1

  name          = var.settings.node_resource_group_name
  resource_type = "azurerm_resource_group"
  prefixes      = try(var.settings.naming_convention.node_resource_group.prefixes, try(var.global_settings.prefixes, null))
  suffixes      = try(var.settings.naming_convention.node_resource_group.suffixes, try(var.global_settings.suffixes, null))
  random_length = try(var.settings.naming_convention.node_resource_group.random_length, try(var.global_settings.random_length, null))
  clean_input   = true
  passthrough   = try(var.settings.naming_convention.node_resource_group.passthrough, try(var.global_settings.passthrough, null))
  use_slug      = try(var.settings.naming_convention.node_resource_group.use_slug, try(var.global_settings.use_slug, null))
}


resource "azurerm_kubernetes_cluster" "k8s" {
  name                                = azurecaf_name.aks.result
  location                            = var.global_settings.regions[lookup(var.settings, "region", var.global_settings.default_region)]
  resource_group_name                 = var.resource_group.name
  sku_tier                            = var.settings.sku_tier
  automatic_channel_upgrade           = var.settings.automatic_channel_upgrade
  node_os_channel_upgrade             = var.settings.node_os_channel_upgrade
  dns_prefix                          = local.aks_dns_name_prefix                          # One of dns_prefix or dns_prefix_private_cluster must be set but not both
  dns_prefix_private_cluster          = try(var.settings.dns_prefix_private_cluster, null) # One of dns_prefix or dns_prefix_private_cluster must be set but not both
  kubernetes_version                  = var.settings.kubernetes_version
  node_resource_group                 = try(azurecaf_name.rg_node[0].result, null) #"MC_${substr(azurerm_resource_group.cluster.name, 0, 15)}_${azurecaf_name.azurerm_kubernetes_cluster_k8s.result}"
  private_cluster_enabled             = var.settings.private_cluster_enabled
  private_dns_zone_id                 = var.settings.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.settings.private_cluster_public_fqdn_enabled
  api_server_access_profile {
    authorized_ip_ranges = var.settings.api_server_authorized_ip_ranges
  }

  default_node_pool {
    name                         = azurecaf_name.default_node_pool.result
    type                         = "VirtualMachineScaleSets"
    enable_auto_scaling          = var.settings.default_node_pool.enable_auto_scaling
    enable_host_encryption       = var.settings.default_node_pool.enable_host_encryption
    enable_node_public_ip        = var.settings.default_node_pool.enable_node_public_ip
    min_count                    = var.settings.default_node_pool.min_count
    max_count                    = var.settings.default_node_pool.max_count
    max_pods                     = var.settings.default_node_pool.max_pods
    node_count                   = var.settings.default_node_pool.node_count
    node_labels                  = var.settings.default_node_pool.node_labels
    only_critical_addons_enabled = var.settings.default_node_pool.only_critical_addons_enabled
    orchestrator_version         = var.settings.default_node_pool.orchestrator_version
    os_disk_size_gb              = var.settings.default_node_pool.os_disk_size_gb
    os_disk_type                 = var.settings.default_node_pool.os_disk_type
    os_sku                       = var.settings.default_node_pool.os_sku
    vm_size                      = var.settings.default_node_pool.vm_size
    vnet_subnet_id               = var.vnets[var.settings.default_node_pool.vnet_key].subnets[var.settings.default_node_pool.vnet_subnet_key].id
    pod_subnet_id                = var.settings.default_node_pool.pod_subnet_key == null ? null : try(var.vnets[var.settings.default_node_pool.vnet_key].subnets[var.settings.default_node_pool.pod_subnet_key].id, null)
    zones                        = var.settings.default_node_pool.availability_zones

    dynamic "upgrade_settings" {
      for_each = try(var.settings.default_node_pool.upgrade_settings, null) == null ? [] : [1]
      content {
        max_surge = upgrade_settings.value.max_surge
      }
    }
    dynamic "linux_os_config" {
      for_each = try(var.settings.default_node_pool.linux_os_config[*], {})
      content {
        dynamic "sysctl_config" {
          for_each = try(linux_os_config.value.sysctl_config[*], {})
          content {
            net_ipv4_tcp_keepalive_intvl  = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
            net_ipv4_tcp_keepalive_probes = sysctl_config.value.net_ipv4_tcp_keepalive_probes
            net_ipv4_tcp_keepalive_time   = sysctl_config.value.net_ipv4_tcp_keepalive_time
          }
        }
      }
    }
  }

  dynamic "identity" {
    for_each = try(var.settings.identity, null) == null ? [] : [1]
    content {
      type         = var.settings.identity.type
      identity_ids = var.settings.identity.identity_ids
    }
  }

  dynamic "kubelet_identity" {
    for_each = try(var.settings.kubelet_identity, null) == null ? [] : [1]
    content {
      client_id                 = try(kubelet_identity.value.client_id, try(var.managed_identities[kubelet_identity.value.managed_identity_key].client_id, null))
      object_id                 = try(kubelet_identity.value.object_id, try(var.managed_identities[kubelet_identity.value.managed_identity_key].principal_id, null))
      user_assigned_identity_id = try(kubelet_identity.value.user_assigned_identity_id, try(var.managed_identities[kubelet_identity.value.managed_identity_key].id, null))
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = try(var.settings.auto_scaler_profile, null) == null ? [] : [1]
    content {
      balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
      expander                         = auto_scaler_profile.value.expander
      empty_bulk_delete_max            = auto_scaler_profile.value.empty_bulk_delete_max
      max_graceful_termination_sec     = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time       = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes                = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage           = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay           = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add       = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete    = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure   = auto_scaler_profile.value.scale_down_delay_after_failure
      scale_down_unneeded              = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready               = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
      scan_interval                    = auto_scaler_profile.value.scan_interval
      skip_nodes_with_local_storage    = auto_scaler_profile.value.skip_nodes_with_local_storage
      skip_nodes_with_system_pods      = auto_scaler_profile.value.skip_nodes_with_system_pods
    }
  }

  dynamic "aci_connector_linux" {
    for_each = try(var.settings.aci_connector_linux[*], [])
    content {
      subnet_name = aci_connector_linux.value.subnet_name
    }
  }

  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [0, 1, 2, 3, 4]
    }
  }

  network_profile {
    dns_service_ip      = var.settings.network_profile.dns_service_ip
    docker_bridge_cidr  = var.settings.network_profile.docker_bridge_cidr
    ip_versions         = var.settings.network_profile.ip_versions
    load_balancer_sku   = var.settings.network_profile.load_balancer_sku
    network_plugin      = var.settings.network_profile.network_plugin
    network_policy      = var.settings.network_profile.network_policy
    network_plugin_mode = var.settings.network_profile.network_plugin_mode
    service_cidr        = var.settings.network_profile.service_cidr
    service_cidrs       = var.settings.network_profile.service_cidrs
    pod_cidr            = var.settings.network_profile.pod_cidr
    pod_cidrs           = var.settings.network_profile.pod_cidrs
    outbound_type       = var.settings.network_profile.outbound_type

    dynamic "load_balancer_profile" {
      for_each = try(var.settings.network_profile.load_balancer_profile[*], {})
      content {
        idle_timeout_in_minutes     = load_balancer_profile.value.idle_timeout_in_minutes
        managed_outbound_ip_count   = load_balancer_profile.value.managed_outbound_ip_count
        managed_outbound_ipv6_count = load_balancer_profile.value.managed_outbound_ipv6_count
        outbound_ip_address_ids     = load_balancer_profile.value.outbound_ip_address_ids
        outbound_ip_prefix_ids      = load_balancer_profile.value.outbound_ip_prefix_ids
        outbound_ports_allocated    = load_balancer_profile.value.outbound_ports_allocated
      }
    }
    dynamic "nat_gateway_profile" {
      for_each = try(var.settings.network_profile.nat_gateway_profile[*], {})
      content {
        idle_timeout_in_minutes   = nat_gateway_profile.value.idle_timeout_in_minutes
        managed_outbound_ip_count = nat_gateway_profile.value.managed_outbound_ip_count
      }
    }
  }

  role_based_access_control_enabled = var.settings.role_based_access_control_enabled
  #Enabled RBAC
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = try(var.settings.role_based_access_control[*], {})
    content {
      managed                = azure_active_directory_role_based_access_control.value.managed
      tenant_id              = try(azure_active_directory_role_based_access_control.value.tenant_id, var.client_config.tenant_id)
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
      admin_group_object_ids = try(azure_active_directory_role_based_access_control.value.admin_group_object_ids, try(var.admin_group_object_ids, null))
      client_app_id          = azure_active_directory_role_based_access_control.value.client_app_id
      server_app_id          = azure_active_directory_role_based_access_control.value.server_app_id
      server_app_secret      = azure_active_directory_role_based_access_control.value.server_app_secret
    }
  }

  azure_policy_enabled      = var.settings.azure_policy_enabled
  open_service_mesh_enabled = var.settings.open_service_mesh_enabled
  oidc_issuer_enabled       = var.settings.oidc_issuer_enabled
  workload_identity_enabled = var.settings.workload_identity_enabled
  image_cleaner_enabled     = var.settings.image_cleaner_enabled
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  dynamic "workload_autoscaler_profile" {
    for_each = try(var.settings.workload_autoscaler_profile[*], {})
    content {
      keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
      vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
    }
  }

  dynamic "storage_profile" {
    for_each = try(var.settings.storage_profile[*], {})
    content {
      blob_driver_enabled         = storage_profile.value.blob_driver_enabled
      disk_driver_enabled         = storage_profile.value.disk_driver_enabled
      disk_driver_version         = storage_profile.value.disk_driver_version # v2 driver is in pubic preview and requires a feature flag to enable
      file_driver_enabled         = storage_profile.value.file_driver_enabled
      snapshot_controller_enabled = storage_profile.value.snapshot_controller_enabled
    }
  }

  dynamic "oms_agent" {
    for_each = try(var.settings.oms_agent[*], {})
    content {
      log_analytics_workspace_id      = can(oms_agent.value.log_analytics_workspace_id) && (oms_agent.value.log_analytics_workspace_id != null && oms_agent.value.log_analytics_workspace_id != "") ? oms_agent.value.log_analytics_workspace_id : var.diagnostics.log_analytics_workspaces[oms_agent.value.log_analytics_key].id
      msi_auth_for_monitoring_enabled = oms_agent.value.msi_auth_for_monitoring_enabled
    }
  }

  dynamic "microsoft_defender" {
    for_each = try(var.settings.microsoft_defender[*], {})
    content {
      log_analytics_workspace_id = can(microsoft_defender.value.log_analytics_workspace_id) && (microsoft_defender.value.log_analytics_workspace_id != null && microsoft_defender.value.log_analytics_workspace_id != "") ? microsoft_defender.value.log_analytics_workspace_id : var.diagnostics.log_analytics_workspaces[microsoft_defender.value.log_analytics_key].id
    }
  }

  dynamic "web_app_routing" {
    for_each = try(var.settings.web_app_routing[*], {})
    content {
      dns_zone_id = can(web_app_routing.value.dns_zone_id) && (web_app_routing.value.dns_zone_id != null) ? web_app_routing.value.dns_zone_id : web_app_routing.value.lz_key == null ? var.public_dns_zones[var.client_config.landingzone_key][web_app_routing.value.dns_zone_key].id : var.public_dns_zones[web_app_routing.value.lz_key][web_app_routing.value.dns_zone_key].id
    }
  }

  tags = local.tags
  lifecycle {
    ignore_changes = [
      identity[0].identity_ids,
      default_node_pool[0].node_count,
      default_node_pool[0].tags, #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#tags
      oms_agent,
      microsoft_defender,
      tags
    ]
  }
}

#
# Node pools
#
resource "azurecaf_name" "nodepools" {
  for_each = try(var.settings.node_pools, {})

  name          = each.value.name
  resource_type = "aks_node_pool_linux"
  prefixes      = try(var.settings.naming_convention.node_pools.prefixes, try(var.global_settings.prefixes, null))
  suffixes      = try(var.settings.naming_convention.node_pools.suffixes, try(var.global_settings.suffixes, null))
  random_length = try(var.settings.naming_convention.node_pools.random_length, try(var.global_settings.random_length, null))
  clean_input   = true
  passthrough   = try(var.settings.naming_convention.node_pools.passthrough, try(var.global_settings.passthrough, null))
  use_slug      = try(var.settings.naming_convention.node_pools.use_slug, try(var.global_settings.use_slug, null))
}
resource "azurerm_kubernetes_cluster_node_pool" "nodepools" {
  for_each = try(var.settings.node_pools, {})

  name                   = azurecaf_name.nodepools[each.key].result
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.k8s.id
  enable_auto_scaling    = each.value.enable_auto_scaling
  enable_host_encryption = each.value.enable_host_encryption
  enable_node_public_ip  = each.value.enable_node_public_ip
  eviction_policy        = each.value.eviction_policy
  fips_enabled           = each.value.fips_enabled
  kubelet_disk_type      = each.value.kubelet_disk_type
  max_count              = each.value.max_count
  min_count              = each.value.min_count
  max_pods               = each.value.max_pods
  mode                   = each.value.mode
  node_count             = each.value.node_count
  node_labels            = each.value.node_labels
  priority               = each.value.priority
  os_disk_size_gb        = each.value.os_disk_size_gb
  os_disk_type           = each.value.os_disk_type
  os_sku                 = each.value.os_sku
  os_type                = each.value.os_type
  spot_max_price         = each.value.spot_max_price
  scale_down_mode        = each.value.scale_down_mode
  ultra_ssd_enabled      = each.value.ultra_ssd_enabled
  vnet_subnet_id         = var.vnets[each.value.vnet_key].subnets[each.value.vnet_subnet_key].id
  pod_subnet_id          = var.settings.default_node_pool.pod_subnet_key == null ? null : try(var.vnets[each.value.vnet_key].subnets[each.value.pod_subnet_key].id, null)
  vm_size                = each.value.vm_size
  workload_runtime       = each.value.workload_runtime
  zones                  = each.value.availability_zones
  orchestrator_version   = each.value.orchestrator_version

  dynamic "upgrade_settings" {
    for_each = try(each.value.upgrade_settings[*], {})
    content {
      max_surge = upgrade_settings.value.max_surge
    }
  }
  dynamic "linux_os_config" {
    for_each = try(var.settings.default_node_pool.linux_os_config[*], {})
    content {
      dynamic "sysctl_config" {
        for_each = try(linux_os_config.value.sysctl_config[*], {})
        content {
          net_ipv4_tcp_keepalive_intvl  = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
          net_ipv4_tcp_keepalive_probes = sysctl_config.value.net_ipv4_tcp_keepalive_probes
          net_ipv4_tcp_keepalive_time   = sysctl_config.value.net_ipv4_tcp_keepalive_time
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      node_count,
      tags
    ]
  }
}
