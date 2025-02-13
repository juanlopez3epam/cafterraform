locals {
    aks_clusters = {
        cluster_re1 = {
            name                              = "instance"
            resource_group_key                = "aks_re1"
            kubernetes_version                = var.aks_clusters-cluster_re1-kubernetes_version
            sku_tier                          = var.aks_clusters-cluster_re1-sku_tier
            #automatic_channel_upgrade        = "stable"       #disable auto upgrade for AKS as it might cause potential outages for MI services, IP-8115
            node_os_channel_upgrade           = var.aks_clusters-cluster_re1-node_os_upgrader_option
            azure_policy_enabled              = true
            image_cleaner_enabled             = true
            role_based_access_control_enabled = true
            oidc_issuer_enabled               = true
            workload_identity_enabled         = true
            identity = {
            type = "SystemAssigned"
            }
            network_profile = {
                network_plugin = "azure"
                network_policy = "azure"
                load_balancer_profile = {
                    outbound_ip_address_ids = var.aks_clusters-cluster_re1-outbound_ip_prefix_ids
                }
            }
            api_server_authorized_ip_ranges = var.aks_clusters-cluster_re1-api_server_authorized_ip_ranges
            workload_autoscaler_profile = {
            keda_enabled                    = true
            vertical_pod_autoscaler_enabled = true
            }
            web_app_routing = {
            dns_zone_id = ""
            }
            default_node_pool = {
                name                      = "systempool"
                enable_auto_scaling       = var.aks_clusters-cluster_re1-default_node_pool-enable_auto_scaling
                enable_encryption_at_host = true
                min_count                 = var.aks_clusters-cluster_re1-default_node_pool-enable_auto_scaling ? var.aks_clusters-cluster_re1-default_node_pool-min_count : null
                max_count                 = var.aks_clusters-cluster_re1-default_node_pool-enable_auto_scaling ? var.aks_clusters-cluster_re1-default_node_pool-max_count : null
                os_disk_size_gb           = var.aks_clusters-cluster_re1-default_node_pool-os_disk_size_gb
                vm_size                   = var.aks_clusters-cluster_re1-default_node_pool-vm_size
                vnet_key                  = "vnet-01"
                vnet_subnet_key           = "aks_system"
                availability_zones        = var.aks_clusters-cluster_re1-default_node_pool-availability_zones
                orchestrator_version      = var.aks_clusters-cluster_re1-kubernetes_version
                linux_os_config           = {
                    sysctl_config  = {
                        net_ipv4_tcp_keepalive_intvl  = 75
                        net_ipv4_tcp_keepalive_probes = 9
                        net_ipv4_tcp_keepalive_time   = 300
                    }
                }
            }
            node_pools = {
            pool1 = {
                name                      = "workerpool1"
                enable_auto_scaling       = var.aks_clusters-cluster_re1-pool1-enable_auto_scaling
                enable_encryption_at_host = true
                min_count                 = var.aks_clusters-cluster_re1-pool1-enable_auto_scaling ? var.aks_clusters-cluster_re1-pool1-min_count : null
                max_count                 = var.aks_clusters-cluster_re1-pool1-enable_auto_scaling ? var.aks_clusters-cluster_re1-pool1-max_count : null
                os_disk_size_gb           = var.aks_clusters-cluster_re1-pool1-os_disk_size_gb
                vm_size                   = var.aks_clusters-cluster_re1-pool1-vm_size
                vnet_key                  = "vnet-01"
                vnet_subnet_key           = "aks_pool_1"
                availability_zones        = var.aks_clusters-cluster_re1-pool1-availability_zones
                orchestrator_version      = var.aks_clusters-cluster_re1-kubernetes_version
                linux_os_config           = {
                    sysctl_config  = {
                        net_ipv4_tcp_keepalive_intvl  = 75
                        net_ipv4_tcp_keepalive_probes = 9
                        net_ipv4_tcp_keepalive_time   = 300
                    }
                }
            }
            }
            naming_convention = {
            default_node_pool = {
                prefixes      = []
                suffixes      = []
                random_length = 0
            }
            node_pools = {
                prefixes      = []
                suffixes      = []
                random_length = 0
            }
            }
            diagnostic_profiles = {
            central_logs = {
                definition_key   = "azure_kubernetes_cluster"
                destination_type = "log_analytics"
                destination_key  = "central_logs_dedicated"
            }
            }
            microsoft_defender = {
            log_analytics_key = "law1"
            }
        }
        }

}
