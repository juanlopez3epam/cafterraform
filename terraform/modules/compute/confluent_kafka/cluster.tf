resource "confluent_environment" "cf_env" {
  display_name = var.cluster_settings.env_display_name

  lifecycle {
    ignore_changes = []
  }
}


resource "confluent_kafka_cluster" "cluster_re1" {
  display_name = var.cluster_settings.display_name
  availability = var.cluster_settings.availability
  cloud        = var.cluster_settings.cloud
  region       = var.cluster_settings.region
  dedicated {
    cku = var.cluster_settings.cku
  }

  environment {
    id = confluent_environment.cf_env.id
  }

  network {
    id = confluent_network.private-link.id
  }
  lifecycle {
    ignore_changes = []
  }
  timeouts {
    create = "90m"  # default is 60 mins
  }
}


// applicable only for dedicated clusters
//https://docs.confluent.io/cloud/current/clusters/broker-config.html#restrict-ciphers


resource "confluent_kafka_cluster_config" "cluster_config" {
  kafka_cluster {
    id = confluent_kafka_cluster.cluster_re1.id
  }
  rest_endpoint = confluent_kafka_cluster.cluster_re1.rest_endpoint
  config = {
    "auto.create.topics.enable" = "true"
    "log.retention.ms" = "1296000000"
    "num.partitions" = "10"
    "ssl.cipher.suites" = "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256"
  }
  credentials {
    key    = confluent_api_key.admin-sa-kafka-api-key.id
    secret = confluent_api_key.admin-sa-kafka-api-key.secret
  }

   depends_on = [
      azurerm_private_dns_zone_virtual_network_link.confluent_kafka_pvt_dns_zone_gh_runner_vnet_link,
      azurerm_private_endpoint.confluent_kafka_gh_runner_pvt_endpoint,
      azurerm_private_dns_a_record.confluent_kafka_zonal_pvt_dns_zone_record_gh_runner,
      azurerm_private_dns_a_record.confluent_kafka_non_zonal_pvt_dns_zone_record_gh_runner,
      #confluent_kafka_cluster.cluster_re1
      confluent_role_binding.admin-sa-kafka-cluster-admin,
      confluent_private_link_access.azure,
      azurerm_private_dns_zone_virtual_network_link.confluent_kafka_pvt_dns_zone_vnet_links,
      azurerm_private_dns_a_record.confluent_kafka_non_zonal_pvt_dns_zone_record,
      azurerm_private_dns_a_record.confluent_kafka_zonal_pvt_dns_zone_records #required only for multizone clusters
   ]

}

resource "confluent_service_account" "admin-sa" {
  display_name = format("%s-sa", var.cluster_settings.display_name)
  description  = "Service account to manage 'inventory' Kafka cluster"
}

resource "confluent_role_binding" "admin-sa-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.admin-sa.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.cluster_re1.rbac_crn
}

resource "confluent_api_key" "admin-sa-kafka-api-key" {
  display_name = format("%s-sa-api-key", var.cluster_settings.display_name)
  description  = "Kafka API Key that is owned by 'admin-sa' service account"

  # Set optional `disable_wait_for_ready` attribute (defaults to `false`) to `true` if the machine where Terraform is not run within a private network
  #disable_wait_for_ready = true
  owner {
    id          = confluent_service_account.admin-sa.id
    api_version = confluent_service_account.admin-sa.api_version
    kind        = confluent_service_account.admin-sa.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.cluster_re1.id
    api_version = confluent_kafka_cluster.cluster_re1.api_version
    kind        = confluent_kafka_cluster.cluster_re1.kind

    environment {
      id = confluent_environment.cf_env.id
    }
  }
   depends_on = [
      azurerm_private_dns_zone_virtual_network_link.confluent_kafka_pvt_dns_zone_gh_runner_vnet_link,
      azurerm_private_endpoint.confluent_kafka_gh_runner_pvt_endpoint,
      azurerm_private_dns_a_record.confluent_kafka_zonal_pvt_dns_zone_record_gh_runner,
      azurerm_private_dns_a_record.confluent_kafka_non_zonal_pvt_dns_zone_record_gh_runner,
      confluent_role_binding.admin-sa-kafka-cluster-admin,
      confluent_private_link_access.azure,
      azurerm_private_dns_zone_virtual_network_link.confluent_kafka_pvt_dns_zone_vnet_links,
      azurerm_private_dns_a_record.confluent_kafka_non_zonal_pvt_dns_zone_record,
      azurerm_private_endpoint.confluent_kafka_pvt_endpoints,
      azurerm_private_dns_a_record.confluent_kafka_zonal_pvt_dns_zone_records
   ]
}


resource "azurerm_key_vault_secret" "cluster-api-key-id" {
  name         = "kafka-api-key-id" #format("%s-api-key-id", var.cluster_settings.display_name)
  value        = confluent_api_key.admin-sa-kafka-api-key.id
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.cluster_settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "cluster-api-key-secret" {
  name         = "kafka-api-key-secret" #format("%s-api-key-secret", var.cluster_settings.display_name)
  value        = confluent_api_key.admin-sa-kafka-api-key.secret
  key_vault_id = var.keyvaults[var.client_config.landingzone_key][var.cluster_settings.keyvault_key].id

  lifecycle {
    ignore_changes = [
      value, key_vault_id
    ]
  }
}

resource "confluent_network" "private-link" {
  display_name     = "Private Link Network"
  cloud            = "AZURE"
  region           = var.cluster_settings.region
  connection_types = ["PRIVATELINK"]
  environment {
    id = confluent_environment.cf_env.id
  }
  dns_config {
    resolution = "PRIVATE"
  }
}

resource "confluent_private_link_access" "azure" {
  display_name = "Azure Private Link Access"
  azure {
    subscription = var.client_config.subscription_id
  }
  environment {
    id = confluent_environment.cf_env.id
  }
  network {
    id = confluent_network.private-link.id
  }
}


resource "azurerm_private_dns_zone" "confluent_kafka_pvt_dns_hosted_zone" {
  resource_group_name = local.az_kafka_con_private_endpoint_rg
  name                = local.hosted_zone
}

resource "azurerm_private_endpoint" "confluent_kafka_pvt_endpoints" {
  for_each            = local.az_kafka_con_private_endpoint_subnet_name_by_zone
  name                = "confluent-${local.network_id}-${each.key}-pvt-endpoint"
  location            = local.az_kafka_con_private_endpoint_location  
  resource_group_name = local.az_kafka_con_private_endpoint_rg
  subnet_id           = local.az_kafka_con_private_endpoint_subnet_id

  private_service_connection {
    name                                 = "confluent-${local.network_id}-${each.key}"
    is_manual_connection                 = true
    private_connection_resource_alias    = lookup(confluent_network.private-link.azure[0].private_link_service_aliases, each.key, "\n\nerror: ${each.key} subnet is missing from CCN's Private Link service aliases")
    request_message                      = "PL"
  }
  #   depends_on = [
  #   confluent_private_link_access.azure,
  #   confluent_kafka_cluster_config.cluster_config
  # ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "confluent_kafka_pvt_dns_zone_vnet_links" {
  for_each              = var.vnets
  name                  = "${local.az_kafka_con_private_endpoint_vnet_name}-${each.key}-kafka-dns-link"  
  resource_group_name   = local.az_kafka_con_private_endpoint_rg
  private_dns_zone_name = azurerm_private_dns_zone.confluent_kafka_pvt_dns_hosted_zone.name
  virtual_network_id    = each.value.id
  # depends_on = [
  #   confluent_private_link_access.azure,
  #   confluent_kafka_cluster_config.cluster_config
  # ]
}


resource "azurerm_private_dns_a_record" "confluent_kafka_non_zonal_pvt_dns_zone_record" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.confluent_kafka_pvt_dns_hosted_zone.name
  resource_group_name = local.az_kafka_con_private_endpoint_rg
  ttl                 = 60
  records = [
    for _, ep in azurerm_private_endpoint.confluent_kafka_pvt_endpoints : ep.private_service_connection[0].private_ip_address
  ]
}


# the below snippet is used only for multi zone availabilty kafka clusters

resource "azurerm_private_dns_a_record" "confluent_kafka_zonal_pvt_dns_zone_records" {
  for_each            = local.az_kafka_con_private_endpoint_subnet_name_by_zone
  name                = "*.az${each.key}"
  zone_name           = azurerm_private_dns_zone.confluent_kafka_pvt_dns_hosted_zone.name
  resource_group_name = local.az_kafka_con_private_endpoint_rg
  ttl                 = 60
  records = [
    azurerm_private_endpoint.confluent_kafka_pvt_endpoints[each.key].private_service_connection[0].private_ip_address,
  ]
}


locals {
  hosted_zone = length(regexall(".glb", resource.confluent_kafka_cluster.cluster_re1.bootstrap_endpoint)) > 0 ? replace(regex("^[^.]+-([0-9a-zA-Z]+[.].*):[0-9]+$", resource.confluent_kafka_cluster.cluster_re1.rest_endpoint)[0], "glb.", "") : regex("[.]([0-9a-zA-Z]+[.].*):[0-9]+$", resource.confluent_kafka_cluster.cluster_re1.bootstrap_endpoint)[0]
  network_id  = regex("^([^.]+)[.].*", local.hosted_zone)[0]
  az_kafka_con_private_endpoint_location  = var.vnets[var.cluster_settings.vnet_key].location #same location as hdinsights vnet
  az_kafka_con_private_endpoint_vnet_id  = var.vnets[var.cluster_settings.vnet_key].id #same location as hdinsights vnet
  az_kafka_con_private_endpoint_vnet_name  = var.vnets[var.cluster_settings.vnet_key].name #same location as hdinsights vnet
  az_kafka_con_private_endpoint_rg  = var.vnets[var.cluster_settings.vnet_key].resource_group_name #same resource group as hdinsights vnet
  az_kafka_con_private_endpoint_subnet_name  = var.cluster_settings.vnet_subnet_key == null ? null : var.vnets[var.cluster_settings.vnet_key].subnets[var.cluster_settings.vnet_subnet_key].name
  az_kafka_con_private_endpoint_subnet_id  = var.cluster_settings.vnet_subnet_key == null ? null : var.vnets[var.cluster_settings.vnet_key].subnets[var.cluster_settings.vnet_subnet_key].id
  az_kafka_con_private_endpoint_subnet_name_by_zone  = {"1" = local.az_kafka_con_private_endpoint_subnet_name,"2" = local.az_kafka_con_private_endpoint_subnet_name,"3" = local.az_kafka_con_private_endpoint_subnet_name}
}

#https://docs.confluent.io/cloud/current/networking/private-links/azure-privatelink.html
# Set up Private Endpoints for Azure Private Link in your Azure subscription
# Set up DNS records to use Azure Private Endpoints
/*
provider "azurerm" {
  features {
  }
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

locals {
  hosted_zone = length(regexall(".glb", confluent_kafka_cluster.cluster.bootstrap_endpoint)) > 0 ? replace(regex("^[^.]+-([0-9a-zA-Z]+[.].*):[0-9]+$", confluent_kafka_cluster.cluster.rest_endpoint)[0], "glb.", "") : regex("[.]([0-9a-zA-Z]+[.].*):[0-9]+$", confluent_kafka_cluster.cluster.bootstrap_endpoint)[0]
  network_id  = regex("^([^.]+)[.].*", local.hosted_zone)[0]
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  for_each = var.subnet_name_by_zone

  name                 = each.value
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "confluent_kafka_pvt_dns_hosted_zone" {
  resource_group_name = data.azurerm_resource_group.rg.name

  name = local.hosted_zone
}

resource "azurerm_private_endpoint" "endpoint" {
  for_each = var.subnet_name_by_zone

  name                = "confluent-${local.network_id}-${each.key}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg.name

  subnet_id = data.azurerm_subnet.subnet[each.key].id

  private_service_connection {
    name                              = "confluent-${local.network_id}-${each.key}"
    is_manual_connection              = true
    private_connection_resource_alias = lookup(confluent_network.private-link.azure[0].private_link_service_aliases, each.key, "\n\nerror: ${each.key} subnet is missing from CCN's Private Link service aliases")
    request_message                   = "PL"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "confluent_kafka_pvt_dns_zone_vnet_links" {
  name                  = data.azurerm_virtual_network.vnet.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.confluent_kafka_pvt_dns_hosted_zone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "rr" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.confluent_kafka_pvt_dns_hosted_zone.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 60
  records = [
    for _, ep in azurerm_private_endpoint.confluent_kafka_pvt_endpoints : ep.private_service_connection[0].private_ip_address
  ]
}

resource "azurerm_private_dns_a_record" "zonal" {
  for_each = var.subnet_name_by_zone

  name                = "*.az${each.key}"
  zone_name           = azurerm_private_dns_zone.confluent_kafka_pvt_dns_hosted_zone.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 60
  records = [
    azurerm_private_endpoint.confluent_kafka_pvt_endpoints[each.key].private_service_connection[0].private_ip_address,
  ]
}


*/
