locals {
  object_id = coalesce(var.logged_user_object_id, var.logged_aad_app_object_id, try(data.azurerm_client_config.current.object_id, null), try(data.azuread_service_principal.logged_in_app[0].object_id, null))
  client_config = var.client_config == {} ? {
    client_id                = data.azurerm_client_config.current.client_id
    landingzone_key          = var.current_landingzone_key
    logged_aad_app_object_id = local.object_id
    logged_user_object_id    = local.object_id
    object_id                = local.object_id
    subscription_id          = data.azurerm_client_config.current.subscription_id
    tenant_id                = data.azurerm_client_config.current.tenant_id
  } : map(var.client_config)

  level_2 = data.terraform_remote_state.level2.outputs

  consolidated_objects_container_registries = merge(
    try(local.level_2.container_registries, {}),
    try(tomap({ (local.client_config.landingzone_key) = module.container_registries }), {})
  )
  consolidated_objects_log_analytics_workspaces = merge(
    try(local.level_2.log_analytics_workspaces, {}),
    try(tomap({ (local.client_config.landingzone_key) = module.log_analytics }), {})
  )
  consolidated_objects_resource_groups = merge(
    try(local.level_2.resource_groups, {}),
    try(tomap({ (local.client_config.landingzone_key) = module.resource_group }), {})
  )

  consolidated_objects_virtual_networks = merge(
    try(local.level_2.virtual_networks, {}),
    tomap({ (local.client_config.landingzone_key) = module.virtual_network })
  )

  consolidated_objects_private_dns_zones = merge(
    try(local.level_2.private_dns_zones, {}),
    tomap({ (local.client_config.landingzone_key) = module.private_dns_zone })
  )

  consolidated_objects_ddos_protection_plans = try(local.level_2.ddos_protection_plans, {})

  remote_state = {
    resource_group_name  = var.remote_state-resource_group_name
    storage_account_name = var.remote_state-storage_account_name
    container_name       = "level2"
    key                  = "state"
  }

  sampleorg_tags = try(local.level_2.sampleorg_tags, {})

  resource_groups = {
    vnet-01 = {
      name = "sp-network"
      # region = "region1"
      tags = local.sampleorg_tags
    }
    monitoring = {
      name = "sp-monitoring"
      tags = local.sampleorg_tags
    }
  }
  public_ip_addresses = merge(
    {},
    var.create-public_ip_address-kong-lb ? {
      kong_load_balancer = {
        name                    = "konglb"
        # region                = "region1"
        resource_group_key      = "vnet-01"
        sku                     = "Standard"
        allocation_method       = "Static"
        ip_version              = "IPv4"
        idle_timeout_in_minutes = var.kong-lb-idle-timeout
      }
    } : {}
  )

  container_registries = {
    # nonprod = {
    #   name               = "mdm"
    #   resource_group_key = "acr-01"
    #   sku                = "Standard"
    #   naming_convention = {
    #     prefixes = []
    #     suffixes = [
    #       "sampleorg",
    #       "test"
    #     ]
    #   }
    # }
  }

  virtual_networks = {
    vnet-01 = {
      resource_group_key = "vnet-01"
      vnet = {
        name          = "01"
        address_space = var.virtual_networks-vnet01-vnet-address_space #["10.22.0.0/17"] # 10.22.0.0 - 10.22.127.255
      }
      dns = {
        dns_server_ips = var.virtual_networks-vnet01-dns-dns_server_ips #["10.84.0.132"] # This should usually be set to the firewall private IP.  Requires firewall policy with DNS Proxy enabled.
      }

      ddos_protection_plan = var.ddos_protection_plan_enabled ? {
        lz_key                   = "core_lvl2"
        ddos_protection_plan_key = "default"
      } : {}
      
    }
    confluent = {
      resource_group_key = "vnet-01"
      vnet = {
        name          = "confluent"
        address_space = var.virtual_networks-confluent-vnet-address_space #["10.22.128.0/26"] # 10.22.128.0 - 10.22.128.63
      }

      ddos_protection_plan = var.ddos_protection_plan_enabled ? {
        lz_key                   = "core_lvl2"
        ddos_protection_plan_key = "default"
      } : {}
      
    }
  }

  virtual_hub_connections = {
    vnet-01_hub = {
      name                      = "core_hub"
      vnet_key                  = "vnet-01"
      vhub_key                  = "vhub"
      internet_security_enabled = true
    }
    confluent_hub = {
      name                      = "confluent_hub"
      vnet_key                  = "confluent"
      vhub_key                  = "vhub"
      internet_security_enabled = true
    }
  }

  private_dns_zones = {
    postgres = {
      name               = var.private_dns_zones-postgres-name
      resource_group_key = "vnet-01"
      vnet_links = {
        hub = {
          vnet_key = "con-01"
          lz_key   = "core_lvl2"
        }
        spoke = {
          vnet_key = "vnet-01"
        }
      }
    }
  }
  private_dns_vnet_links =  {
    redis = {
      name                  = "privatelink.redisenterprise.cache.azure.net"
      resource_group_key    = "dns-01"
      resource_group_lz_key = "core_lvl2"
      vnet_lz_key           = var.current_landingzone_key
      vnet_key              = "vnet-01"
    }
    blob = {
      name                  = "privatelink.blob.core.windows.net"
      resource_group_key    = "dns-01"
      resource_group_lz_key = "core_lvl2"
      vnet_lz_key           = var.current_landingzone_key
      vnet_key              = "vnet-01"
    }
  }

  log_analytics = {
    law1 = {
      name               = "central"
      resource_group_key = "monitoring"
    }
  }

}

