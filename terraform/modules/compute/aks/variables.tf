variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = null
}
variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}
variable "settings" {
  description = "AKS settings object (see module README.md)"
  type = object({
    api_server_authorized_ip_ranges     = optional(list(string), null)
    automatic_channel_upgrade           = optional(string, null)
    node_os_channel_upgrade             = optional(string, null)
    azure_policy_enabled                = optional(bool, true)
    dns_prefix                          = optional(string, null)
    dns_prefix_private_cluster          = optional(string, null)
    kubernetes_version                  = optional(string, null)
    image_cleaner_enabled               = optional(bool, null)
    node_resource_group_name            = optional(string, null)
    oidc_issuer_enabled                 = optional(bool, null)
    open_service_mesh_enabled           = optional(bool, null)
    private_cluster_enabled             = optional(bool, null)
    private_dns_zone_id                 = optional(string, null)
    private_cluster_public_fqdn_enabled = optional(bool, null)
    role_based_access_control_enabled   = optional(bool, true)
    sku_tier                            = optional(string, "Free") # Free or Paid
    workload_identity_enabled           = optional(bool, null)
    aci_connector_linux = optional(object({
      subnet_name = optional(string, null)
    }), null)
    auto_scaler_profile = optional(object({
      balance_similar_node_groups      = optional(bool, null)
      expander                         = optional(string, null) # least_waste | most_pods | least_utilized | most_utilized | random
      empty_bulk_delete_max            = optional(number, null)
      max_graceful_termination_sec     = optional(string, null)
      max_node_provision_time          = optional(string, null)
      max_unready_nodes                = optional(number, null)
      max_unready_percentage           = optional(number, null)
      new_pod_scale_up_delay           = optional(string, null)
      scale_down_delay_after_add       = optional(string, null)
      scale_down_delay_after_delete    = optional(string, null)
      scale_down_delay_after_failure   = optional(string, null)
      scale_down_unneeded              = optional(string, null)
      scale_down_unready               = optional(string, null)
      scale_down_utilization_threshold = optional(string, null)
      scan_interval                    = optional(string, null)
      skip_nodes_with_local_storage    = optional(bool, null)
      skip_nodes_with_system_pods      = optional(bool, null)
    }))
    role_based_access_control = optional(object({
      azure_active_directory = optional(object({
        admin_group_object_ids = optional(list(string), null)
        azure_rbac_enabled     = optional(bool, true)
        client_app_id          = optional(string, null)
        managed                = optional(bool, true)
        server_app_id          = optional(string, null)
        server_app_secret      = optional(string, null) #BEWARE This will leak the secret as it is a plain text string stored in the tfvars file. DO NOT USE!
        tenant_id              = optional(string, null)
      }), null)
    }), null)
    identity = optional(object({
      type          = optional(string, "SystemAssigned") # SystemAssigned | UserAssigned 
      identity_ids  = optional(set(string), null)
      identity_keys = optional(set(string), null)
    }), null)
    kubelet_identity = optional(object({
      client_id                 = optional(string, null)
      object_id                 = optional(string, null)
      user_assigned_identity_id = optional(string, null)
      managed_identity_key      = optional(string, null)
    }), null)
    #maintenance_window = optional()
    microsoft_defender = optional(object({
      log_analytics_workspace_id = optional(string, null)
      log_analytics_key          = optional(string, null)
    }), null)
    network_profile = object({
      dns_service_ip     = optional(string, null)
      docker_bridge_cidr = optional(string, null)
      ip_versions        = optional(list(string), null) # ["IPv4", "IPv6"] # requires subscription Feature Registration "Microsoft.ContainerService/AKS-EnableDualStack"
      load_balancer_sku  = optional(string, "standard") # standard or basic
      load_balancer_profile = optional(object({
        idle_timeout_in_minutes     = optional(number, null)
        managed_outbound_ip_count   = optional(number, null)
        managed_outbound_ipv6_count = optional(number, null) # requires subscription Feature Registration "Microsoft.ContainerService/AKS-EnableDualStack"
        outbound_ip_address_ids     = optional(list(string), null)
        outbound_ip_prefix_ids      = optional(list(string), null)
        outbound_ports_allocated    = optional(number, null)
      }), null) # can only be set if load_balancer_sku is "standard"
      nat_gateway_profile = optional(object({
        idle_timeout_in_minutes   = optional(number, null)
        managed_outbound_ip_count = optional(number, null)
      }), null) # can only be set if load_balancer_sku is "standard" and outbound_type is "managedNATGateway" or "userAssignedNATGateway"
      network_plugin      = optional(string, "azure")
      network_policy      = optional(string, "azure")
      network_plugin_mode = optional(string, null) # required subscription Feature Registration "Microsoft.ContainerService/AzureOverlayPreview"
      pod_cidr            = optional(string, null)
      pod_cidrs           = optional(list(string), null)
      service_cidr        = optional(string, null)
      service_cidrs       = optional(list(string), null)
      outbound_type       = optional(string, "loadBalancer") # loadBalancer | userDefinedRouting | managedNATGateway | userAssignedNATGateway
    })
    storage_profile = optional(object({
      blob_driver_enabled         = optional(bool, true)
      disk_driver_enabled         = optional(bool, true)
      disk_driver_version         = optional(string, "v1") # v1 or v2 # requires subscription Feature Registration "Microsoft.ContainerService/EnableAzureDiskCSIDriverV2"
      file_driver_enabled         = optional(bool, true)
      snapshot_controller_enabled = optional(bool, true)
      }), {
      blob_driver_enabled         = true
      disk_driver_enabled         = true
      disk_driver_version         = "v1"
      file_driver_enabled         = true
      snapshot_controller_enabled = true
    })
    oms_agent = optional(object({
      log_analytics_workspace_id      = optional(string, null)
      log_analytics_key               = optional(string, null)
      msi_auth_for_monitoring_enabled = optional(bool, null)
    }), null)
    workload_autoscaler_profile = optional(object({
      keda_enabled                    = optional(bool, null)
      vertical_pod_autoscaler_enabled = optional(bool, null)
    }), null)
    web_app_routing = optional(object({
      lz_key       = optional(string, null)
      dns_zone_key = optional(string, null)
      dns_zone_id  = optional(string, null)
    }), null)
    default_node_pool = object({
      availability_zones           = optional(list(string), null)
      enable_auto_scaling          = optional(bool, true)
      enable_host_encryption       = optional(bool, false) # required subscription Feature Registration
      enable_node_public_ip        = optional(bool, null)
      fips_enabled                 = optional(bool, null)
      max_count                    = optional(number, null)
      min_count                    = optional(number, null)
      max_pods                     = optional(number, 150)
      name                         = optional(string, "systempool")
      node_count                   = optional(number, null)
      node_labels                  = optional(map(string), null)
      only_critical_addons_enabled = optional(bool, true)
      orchestrator_version         = optional(string, null)
      os_disk_size_gb              = optional(number, null)
      os_disk_type                 = optional(string, "Ephemeral") # Ephemeral or Managed
      os_sku                       = optional(string, "Ubuntu")    # Ubuntu or CBLMariner
      vm_size                      = string
      vnet_key                     = optional(string, null)
      vnet_subnet_key              = optional(string, null)
      pod_subnet_key               = optional(string, null) # requires subscription Feature Registration "Microsoft.ContainerService/PodSubnetPreview"
      upgrade_settings = optional(object({
        max_surge = optional(number, null)
      }), null)
      linux_os_config = optional(object({
        sysctl_config = optional(object({
          net_ipv4_tcp_keepalive_intvl  = optional(number, null)
          net_ipv4_tcp_keepalive_probes = optional(number, null)
          net_ipv4_tcp_keepalive_time   = optional(number, null)
        }), null)
      }), null)
    })
    node_pools = optional(map(object({
      availability_zones     = optional(list(string), null)
      enable_auto_scaling    = optional(bool, true)
      enable_host_encryption = optional(bool, false) # required subscription Feature Registration
      enable_node_public_ip  = optional(bool, null)
      eviction_policy        = optional(string, null) # Delete or Deallocate or null for non-spot pools
      fips_enabled           = optional(bool, null)
      kubelet_disk_type      = optional(string, null) # OS or Temporary
      max_count              = optional(number, null)
      min_count              = optional(number, null)
      max_pods               = optional(number, 150)
      mode                   = optional(string, "User") # User or System
      name                   = string
      node_count             = optional(number, null)
      node_labels            = optional(map(string), null)
      priority               = optional(string, null) # Spot or null for non-spot pools
      orchestrator_version   = optional(string, null)
      os_disk_size_gb        = optional(number, null)
      os_disk_type           = optional(string, "Ephemeral")
      os_sku                 = optional(string, "Ubuntu")
      os_type                = optional(string, "Linux")
      scale_down_mode        = optional(string, null) # Delete or Deallocate
      spot_max_price         = optional(number, null) # -1 for on-demand, or a positive value with up to five decimal places, null for non-spot pools
      ultra_ssd_enabled      = optional(bool, null)
      vm_size                = string
      vnet_key               = optional(string, null)
      vnet_subnet_key        = optional(string, null)
      pod_subnet_key         = optional(string, null) # requires subscription Feature Registration "Microsoft.ContainerService/PodSubnetPreview"
      workload_runtime       = optional(string, null) # OCIContainer or WasmWasi
      upgrade_settings = optional(object({
        max_surge = optional(number, null)
      }), null)
      linux_os_config = optional(object({
        sysctl_config = optional(object({
          net_ipv4_tcp_keepalive_intvl  = optional(number, null)
          net_ipv4_tcp_keepalive_probes = optional(number, null)
          net_ipv4_tcp_keepalive_time   = optional(number, null)
        }), null)
      }), null)
    })), null)
    naming_convention = optional(object({
      cluster_name = optional(object({
        prefixes      = optional(list(string), null)
        suffixes      = optional(list(string), null)
        random_length = optional(number, null)
        passthrough   = optional(bool, null)
        use_slug      = optional(bool, null)
      }), null)
      default_node_pool = optional(object({
        prefixes      = optional(list(string), null)
        suffixes      = optional(list(string), null)
        random_length = optional(number, null)
        passthrough   = optional(bool, null)
        use_slug      = optional(bool, null)
      }), null)
      node_resource_group = optional(object({
        prefixes      = optional(list(string), null)
        suffixes      = optional(list(string), null)
        random_length = optional(number, null)
        passthrough   = optional(bool, null)
        use_slug      = optional(bool, null)
      }), null)
      node_pools = optional(object({
        prefixes      = optional(list(string), null)
        suffixes      = optional(list(string), null)
        random_length = optional(number, null)
        passthrough   = optional(bool, null)
        use_slug      = optional(bool, null)
      }), null)
    }), null)
  })
}
variable "name" {
  description = "Name of the AKS cluster"
  type        = string
}
variable "resource_group" {
  description = "Resource group object"
  type        = any
}
variable "tags" {
  description = "(optional) Map of tags to be applied to the resource"
  type        = map(any)
  default     = null
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
  default     = null
}
variable "vnets" {
  description = "Virtual network object"
  type        = map(any)
  default     = null
}
variable "diagnostics" {
  description = "Diagnostics object"
  type = object({
    diagnostics_definition   = optional(any, null)
    diagnostics_destinations = optional(any, null)
    log_analytics_workspaces = optional(any, null)
    eventhub_name            = optional(any, null)
    eventhub_authorization_rule_id = optional(any, null)
  })
  default = null
}
variable "diagnostic_profiles" {
  description = "Diagnostics profiles"
  type = map(object({
    definition_key   = string
    destination_type = string
    destination_key  = string
  }))
  default = null
}
variable "managed_identities" {
  description = "Managed identities objects"
  type        = any
  default     = {}
}
variable "public_dns_zones" {
  description = "Public DNS zones object"
  type        = any
  default     = {}
}
variable "admin_group_object_ids" {
  description = "List of Azure AD group object IDs that should be granted cluster admin access"
  type        = list(string)
  default     = null
}
