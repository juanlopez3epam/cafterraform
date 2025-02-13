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

  consolidated_objects_resource_groups       = tomap({ (local.client_config.landingzone_key) = module.resource_groups })
  consolidated_objects_private_dns_zones     = tomap({ (local.client_config.landingzone_key) = module.private_dns_zone })
  consolidated_objects_virtual_networks      = tomap({ (local.client_config.landingzone_key) = module.virtual_network })
  consolidated_objects_ddos_protection_plans = tomap({ (local.client_config.landingzone_key) = azurerm_network_ddos_protection_plan.ddos_protection_plan })

  private_link_locations = [var.global_settings.loc_code]
  lookup_azure_backup_geo_codes = merge(
    local.builtin_azure_backup_geo_codes,
    # local.custom_azure_backup_geo_codes,
  )

  lookup_private_link_dns_zone_by_service = {
    azure_api_management                 = ["privatelink.azure-api.net", "privatelink.developer.azure-api.net"]
    azure_app_configuration_stores       = ["privatelink.azconfig.io"]
    azure_arc                            = ["privatelink.his.arc.azure.com", "privatelink.guestconfiguration.azure.com", "privatelink.kubernetesconfiguration.azure.com"]
    azure_automation_dscandhybridworker  = ["privatelink.azure-automation.net"]
    azure_automation_webhook             = ["privatelink.azure-automation.net"]
    azure_batch_account                  = ["privatelink.batch.azure.com"]
    azure_bot_service_bot                = ["privatelink.directline.botframework.com"]
    azure_bot_service_token              = ["privatelink.token.botframework.com"]
    azure_cache_for_redis                = ["privatelink.redis.cache.windows.net"]
    azure_cache_for_redis_enterprise     = ["privatelink.redisenterprise.cache.azure.net"]
    azure_container_registry             = ["privatelink.azurecr.io"]
    azure_cosmos_db_cassandra            = ["privatelink.cassandra.cosmos.azure.com"]
    azure_cosmos_db_gremlin              = ["privatelink.gremlin.cosmos.azure.com"]
    azure_cosmos_db_mongodb              = ["privatelink.mongo.cosmos.azure.com"]
    azure_cosmos_db_sql                  = ["privatelink.documents.azure.com"]
    azure_cosmos_db_table                = ["privatelink.table.cosmos.azure.com"]
    azure_data_factory                   = ["privatelink.datafactory.azure.net"]
    azure_data_factory_portal            = ["privatelink.adf.azure.com"]
    azure_data_health_data_services      = ["privatelink.azurehealthcareapis.com", "privatelink.dicom.azurehealthcareapis.com"]
    azure_data_lake_file_system_gen2     = ["privatelink.dfs.core.windows.net"]
    azure_database_for_mariadb_server    = ["privatelink.mariadb.database.azure.com"]
    azure_database_for_mysql_server      = ["privatelink.mysql.database.azure.com"]
    azure_database_for_postgresql_server = ["privatelink.postgres.database.azure.com"]
    azure_digital_twins                  = ["privatelink.digitaltwins.azure.net"]
    azure_elastic_cloud                  = ["privatelink.${var.global_settings.loc_code}.azure.elastic-cloud.com"]
    azure_event_grid_domain              = ["privatelink.eventgrid.azure.net"]
    azure_event_grid_topic               = ["privatelink.eventgrid.azure.net"]
    azure_event_hubs_namespace           = ["privatelink.servicebus.windows.net"]
    azure_file_sync                      = ["privatelink.afs.azure.net"]
    azure_hdinsights                     = ["privatelink.azurehdinsight.net"]
    azure_iot_dps                        = ["privatelink.azure-devices-provisioning.net"]
    azure_iot_hub                        = ["privatelink.azure-devices.net", "privatelink.servicebus.windows.net"]
    azure_key_vault                      = ["privatelink.vaultcore.azure.net"]
    azure_key_vault_managed_hsm          = ["privatelink.managedhsm.azure.net"]
    azure_machine_learning_workspace     = ["privatelink.api.azureml.ms", "privatelink.notebooks.azure.net"]
    azure_managed_disks                  = ["privatelink.blob.core.windows.net"]
    azure_media_services                 = ["privatelink.media.azure.net"]
    azure_migrate                        = ["privatelink.prod.migration.windowsazure.com"]
    azure_monitor                        = ["privatelink.monitor.azure.com", "privatelink.oms.opinsights.azure.com", "privatelink.ods.opinsights.azure.com", "privatelink.agentsvc.azure-automation.net", "privatelink.blob.core.windows.net"]
    azure_purview_account                = ["privatelink.purview.azure.com"]
    azure_purview_studio                 = ["privatelink.purviewstudio.azure.com"]
    azure_relay_namespace                = ["privatelink.servicebus.windows.net"]
    azure_search_service                 = ["privatelink.search.windows.net"]
    azure_service_bus_namespace          = ["privatelink.servicebus.windows.net"]
    azure_site_recovery                  = ["privatelink.siterecovery.windowsazure.com"]
    azure_sql_database_sqlserver         = ["privatelink.database.windows.net"]
    azure_synapse_analytics_dev          = ["privatelink.dev.azuresynapse.net"]
    azure_synapse_analytics_sql          = ["privatelink.sql.azuresynapse.net"]
    azure_synapse_studio                 = ["privatelink.azuresynapse.net"]
    azure_web_apps_sites                 = ["privatelink.azurewebsites.net"]
    azure_web_apps_static_sites          = ["privatelink.azurestaticapps.net"]
    cognitive_services_account           = ["privatelink.cognitiveservices.azure.com"]
    microsoft_power_bi                   = ["privatelink.analysis.windows.net", "privatelink.pbidedicated.windows.net", "privatelink.tip1.powerquery.microsoft.com"]
    signalr                              = ["privatelink.service.signalr.net"]
    signalr_webpubsub                    = ["privatelink.webpubsub.azure.com"]
    storage_account_blob                 = ["privatelink.blob.core.windows.net"]
    storage_account_file                 = ["privatelink.file.core.windows.net"]
    storage_account_queue                = ["privatelink.queue.core.windows.net"]
    storage_account_table                = ["privatelink.table.core.windows.net"]
    storage_account_web                  = ["privatelink.web.core.windows.net"]
    azure_backup = [
      for location in local.private_link_locations :
      "privatelink.${local.lookup_azure_backup_geo_codes[location]}.backup.windowsazure.com"
    ]
    azure_data_explorer = [
      for location in local.private_link_locations :
      "privatelink.${location}.kusto.windows.net"
    ]
    azure_kubernetes_service_management = [
      for location in local.private_link_locations :
      "privatelink.${location}.azmk8s.io"
    ]
  }

  services_by_private_link_dns_zone = transpose(local.lookup_private_link_dns_zone_by_service)

  sampleorg_tags = {
    BusinessUnit = var.tag_bussines_unit
    COGS = var.tag_cogs
    CostCenter = var.tag_cost_center
    Team = var.tag_team
    Environment = var.tag_environment
  }

  resource_groups = {
    con-01 = {
      name = "hb-connectivity"
      tags = local.sampleorg_tags
    }
    # ddos-01 = {
    #   name = "hub-ddos"
    #   tags = local.sampleorg_tags
    # }
    dns-01 = {
      name = "hb-dns"
      tags = local.sampleorg_tags
    }
    security = {
      name = "hb-security"
      tags = local.sampleorg_tags
    }
    management = {
      name = "hb-management"
      tags = local.sampleorg_tags
    }
  }
  
  log_analytics = {
    law_platform = {
      name               = "platform"
      resource_group_key = "management"
      retention_in_days  = var.log_analytics-law_platform-retention_in_days
    }
  }

  ddos_protection_plan = var.ddos_protection_plan_enabled ? local.ddos_protection_plan_local_config : {}
  ddos_protection_plan_local_config = {
    default = {
      resource_group_key = "ddos-01"
    }
  }

  bastion_hosts = {
    bastion_hub_re1 = {
      name               = "bastion-hub"
      region             = "region1"
      resource_group_key = "con-01"
      vnet_key           = "con-01"
      subnet_key         = "bastion"
      public_ip_key      = "bastion_host_rg1"
      sku                = "Standard"
      scale_units        = 4
      copy_paste_enabled = true
      file_copy_enabled  = true
      ip_connect_enabled = true
      tunneling_enabled  = true

      # # you can setup up to 5 profiles
      # diagnostic_profiles = {
      #   central_logs_region1 = {
      #     definition_key   = "bastion_host"
      #     destination_type = "log_analytics"
      #     destination_key  = "central_logs"
      #   }
      # }
    }
  }

  virtual_networks = {
    con-01 = {
      resource_group_key = "con-01"
      vnet = {
        name          = "connectivity"
        address_space = var.virtual_networks01-vnet-address_space
      }

      subnets = {
        bastion = {
          name    = "AzureBastionSubnet"
          cidr    = var.virtual_networks01-subnets-bastion-cidr
          nsg_key = "azure_bastion_nsg"
        }
        jumpbox = {
          name            = "jumpbox"
          cidr            = var.virtual_networks01-subnets-jumpbox-cidr
          nsg_key         = "jumpbox"
        }
        dns_resolver = {
          name                                          = "AzurePrivateDnsResolver"
          cidr                                          = var.virtual_networks01-subnets-dns_resolver-cidr
          nsg_key                                       = "privatednsresolver_nsg"
          private_link_service_network_policies_enabled = true
          delegation = {
            name               = "Microsoft.Network.dnsResolvers"
            service_delegation = "Microsoft.Network/dnsResolvers"
            actions            = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }
      }

      ddos_protection_plan = var.ddos_protection_plan_enabled ? {
        ddos_protection_plan_key = "default"
      } : {}
      
    }
  }

  route_tables = var.jumpbox_route_table_enabled ? local.route_tables_config : {}
  route_tables_config = {
    con-01_jumpbox = {
      resource_group_key = "con-01"
      name               = "con-01-snet-jumpbox"
    }
  }

  routes = var.jumpbox_route_table_enabled ? local.routes_config : {}
  routes_config = {
    con-01_jumpbox_1 = {
      route_table_key        = "con-01_jumpbox"
      name                   = "0.0.0.0"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.routes-con-01_jumpbox-next_hop_in_ip_address
    }
    con-01_jumpbox_2 = {
      route_table_key        = "con-01_jumpbox"
      name                   = var.routes-con-01_jumpbox2-name
      address_prefix         = "${var.routes-con-01_jumpbox2-name}/16"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.routes-con-01_jumpbox-next_hop_in_ip_address
    }
    con-01_jumpbox_3 = {
      route_table_key        = "con-01_jumpbox"
      name                   = var.routes-con-01_jumpbox3-name
      address_prefix         = "${var.routes-con-01_jumpbox3-name}/8"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.routes-con-01_jumpbox-next_hop_in_ip_address
    }
    con-01_jumpbox_4 = {
      route_table_key        = "con-01_jumpbox"
      name                   = var.routes-con-01_jumpbox4-name
      address_prefix         = "${var.routes-con-01_jumpbox4-name}/12"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.routes-con-01_jumpbox-next_hop_in_ip_address
    }
  }

  virtual_wans = {
    vwan = {
      resource_group_key = "con-01"
      name               = ""
      # region             = "region1"
    }
  }

  virtual_hubs = {
    vhub = {
      virtual_wan = {
        key = "vwan"
      }
      resource_group = {
        key = "con-01"
      }
      name           = "hub"
      address_prefix = var.virtual_hubs-vhub-address_prefix
      vnet_connections = {
        default = {
          name = "main"
          vnet = {
            key = "con-01"
          }
          internet_security_enabled = var.virtual_hubs-vhub-vnet_connections-internet_security_enabled #Disabled VHub routing intent propagation to avoid breaking internet connectivity of Azure Bastion
        }
      }
    }
  }

  firewalls = var.firewall_enabled ? local.firewalls_local_config : {}
  firewalls_local_config = {
    fw1 = {
      name                = "hub"
      resource_group_key  = "con-01"
      sku_tier            = var.firewalls-fw1-sku_tier
      sku_name            = "AZFW_Hub"
      zones               = [1, 2, 3]
      firewall_policy_key = "global"
      virtual_hub = {
        vhub = {
          virtual_wan_key = "vwan"
          virtual_hub_key = "vhub"
          public_ip_count = var.firewalls-fw1-vhub-public_ip_count
        }
      }
    }
  }

  public_ip_addresses = {

    bastion_host_rg1 = {
      name = "bastion"
      # region                  = "region1"
      resource_group_key      = "con-01"
      sku                     = var.public_ip_addresses-bastion_host_rg1-sku
      allocation_method       = "Static"
      ip_version              = "IPv4"
      idle_timeout_in_minutes = "4"

    }
  }
  # ==================================================================
  # local values for keyvault.tf modules
  # ==================================================================
  keyvaults = {
    ssh_keys = {
      name               = "bastion"
      resource_group_key = "security"
      sku_name           = var.keyvaults-ssh_keys-sku_name

      enabled_for_deployment = true

      creation_policies = {
        logged_in_identity = {
          key_permissions = [
            "Get",
            "List",
            "Create",
            "Update",
            "Import",
            "Delete",
            "Recover"
          ]
          secret_permissions = [
            "Get",
            "List",
            "Set",
            "Delete",
            "Recover",
            "Backup",
            "Restore",
            "Purge"
          ]
          certificate_permissions = [
            "Get",
            "List",
            "Create",
            "Update",
            "Import",
            "Delete",
            "Recover",
            "Backup"
          ]
        }
      }
    }
  }

  #To Do: check the importance of "xpirit_aad_group" and whats the object id
  keyvault_access_policies = {
    ssh_keys = {
      aad_group = {
        object_id = var.keyvault_access_policies-ssh_keys-aad_group-object_id
        secret_permissions = [
          "Get",
          "List",
          "Set",
          "Delete"
        ]
      }
    }
  }

  private_dns_zones = {
    all = {
      resource_group_key = "dns-01"
      vnet_links = {
        con-01 = {
          vnet_key             = "con-01"
          registration_enabled = false
        }
      }
    }
  }

  private_dns_resolvers = {
    dns_resolver = {
      name               = "resolver"
      resource_group_key = "con-01"
      vnet_key           = "con-01"
      tags               = local.sampleorg_tags

      inbound_endpoints = {
        endpoint = {
          name       = "endpoint"
          subnet_key = "dns_resolver"
        }
      }
    }
  }
  
  # ==================================================================
  # local values for virtual_machines.tf modules
  # ==================================================================
  managed_identities = {
    user_mi = {
      name               = "user_mi"
      resource_group_key = "con-01"
    }
  }


  # Virtual machines
  virtual_machines = {

    # Configuration to deploy a bastion host linux virtual machine
    jumpbox = {
      resource_group_key = "con-01"
      provision_vm_agent = true
      # when boot_diagnostics_storage_account_key is empty string "", boot diagnostics will be put on azure managed storage
      # when boot_diagnostics_storage_account_key is a non-empty string, it needs to point to the key of a user managed storage defined in diagnostic_storage_accounts
      # if boot_diagnostics_storage_account_key is not defined, but global_settings.resource_defaults.virtual_machines.use_azmanaged_storage_for_boot_diagnostics is true, boot diagnostics will be put on azure managed storage

      os_type = "linux"

      # the auto-generated ssh key in keyvault secret. Secret name being {VM name}-ssh-public and {VM name}-ssh-private
      keyvault_key = "ssh_keys"

      # Define the number of networking cards to attach the virtual machine
      networking_interfaces = {
        nic0 = {
          # Value of the keys from networking.tfvars
          vnet_key                = "con-01"
          subnet_key              = "jumpbox"
          name                    = "0-bastion_host"
          enable_ip_forwarding    = false
          internal_dns_name_label = "bastion-host-nic0"

        }
      }

      virtual_machine_settings = {
        linux = {
          name                            = "private_vm"
          size                            = var.jumpbox-vm_settings-size
          admin_username                  = "adminuser"
          disable_password_authentication = true

          # Value of the nic keys to attach the VM. The first one in the list is the default nic
          network_interface_keys = ["nic0"]

          os_disk = {
            name                 = "bastion_host-os"
            caching              = "ReadWrite"
            storage_account_type = var.jumpbox-vm_settings-sa_type
          }

          source_image_reference = {
            publisher = var.jumpbox-vm_settings-source_image-publisher
            offer     = var.jumpbox-vm_settings-source_image-offer
            sku       = var.jumpbox-vm_settings-source_image-sku
            version   = var.jumpbox-vm_settings-source_image-version
          }
          identity = {
            type                  = "UserAssigned"
            managed_identity_keys = ["user_mi"]
          }
        }
      }
    }
  }

  # ==================================================================
  # Definition of the networking security groups
  # ==================================================================
  network_security_group_definition = {
    # This entry is applied to all subnets with no NSG defined
    empty_nsg = {
      resource_group_key = "connectivity"
      name               = "empty_nsg"

      # diagnostic_profiles = {
      #   nsg = {
      #     definition_key   = "network_security_group"
      #     destination_type = "storage"
      #     destination_key  = "all_regions"
      #   }
      #   operations = {
      #     name             = "operations"
      #     definition_key   = "network_security_group"
      #     destination_type = "log_analytics"
      #     destination_key  = "central_logs"
      #   }
      # }
      nsg = []
    }

    azure_bastion_nsg = {
      resource_group_key = "connectivity"
      name               = "azure_bastion_nsg"

      diagnostic_profiles = {
        nsg = {
          definition_key   = "network_security_group"
          destination_type = "storage"
          destination_key  = "all_regions"
        }
        operations = {
          name             = "operations"
          definition_key   = "network_security_group"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }

      nsg = [
        {
          name                       = "bastion-in-allow",
          priority                   = "100"
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }

    jumpbox = {
      resource_group_key = "connectivity"
      name               = "jumpbox"

      diagnostic_profiles = {
        nsg = {
          definition_key   = "network_security_group"
          destination_type = "storage"
          destination_key  = "all_regions"
        }
        operations = {
          name             = "operations"
          definition_key   = "network_security_group"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }

      nsg = []
    }

    privatednsresolver_nsg = {
      resource_group_key = "connectivity"
      name               = "privatednsresolver"

      diagnostic_profiles = {
        nsg = {
          definition_key   = "network_security_group"
          destination_type = "storage"
          destination_key  = "all_regions"
        }
        operations = {
          name             = "operations"
          definition_key   = "network_security_group"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }

      nsg = [
        {
          name                       = "dns-inbound-53"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "53"
          source_address_prefixes    = var.network_restrictions_ip_rule_list
          destination_address_prefix = "VirtualNetwork"
        }
      ]
    }
  }
  #======================================================

  firewall_policies = var.firewall_enabled ? local.firewall_policies_local_config : {}
   firewall_policies_local_config = {
     global = {
       name               = "global"
       resource_group_key = "con-01"
       dns = {
         enabled              = true
         dns_resolver_key     = "dns_resolver"
         inbound_endpoint_key = "endpoint"
       }
       rule_collection_groups = {
         allow_all = {
           name     = "allow-all-rule-collection"
           priority = 500
           network_rule_collections = {
             allow_all = {
               name     = "allow_all_network"
               priority = 500
               action   = "Allow"
               rules = {
                 allow_all_rule = {
                   name                  = "allow_all_network_rule"
                   protocols             = ["Any"]
                   destination_ports     = ["*"]
                   destination_addresses = ["*"]
                   source_addresses      = ["*"]
                 }
               }
             }
           }
           nat_rule_collections = null
         }

         aks_dnat = {
           name                     = "aks-dnat"
           priority                 = 100
           network_rule_collections = null
           nat_rule_collections = {
             stage_aks_dnat = {
               name     = "stage-aks-dnat"
               priority = 100
               rules = {
                 # Kong rules
                 stage_aks_kong_dnat_80 = {
                   name                = "stage-aks-kong-dnat-80"
                   priority            = 100
                   protocols           = ["TCP", "UDP"]
                   source_addresses    = ["*"]
                   destination_address = var.aks_dnat-stage_aks_kong_dnat_80-destination_address
                   destination_ports   = ["80"]
                   translated_address  = var.aks_dnat-stage_aks_kong_dnat_80-translated_address
                   translated_port     = 80
                 }
                 stage_aks_kong_dnat_443 = {
                   name                = "stage-aks-kong-dnat-443"
                   priority            = 101
                   protocols           = ["TCP", "UDP"]
                   source_addresses    = ["*"]
                   destination_address = var.aks_dnat-stage_aks_kong_dnat_443-destination_address
                   destination_ports   = ["443"]
                   translated_address  = var.aks_dnat-stage_aks_kong_dnat_443-translated_address
                   translated_port     = 443
                 }
               }
             }
           }
         }

       }
     }
   }


}
