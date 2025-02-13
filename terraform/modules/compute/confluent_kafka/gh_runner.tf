resource "confluent_private_link_access" "gh_runner" {
  display_name = "Azure Private Link Access"
  count        = var.runner_settings.subscription_id == var.client_config.subscription_id ? 0 : 1
  azure {
    subscription = var.runner_settings.subscription_id
  }
  environment {
    id = confluent_environment.cf_env.id
  }
  network {
    id = confluent_network.private-link.id
  }
}

data "azurerm_virtual_network" "confluent_kafka_gh_runner_vnet" {
  provider            = azurerm.gh_runner
  name                = var.runner_settings.vnet
  resource_group_name = var.runner_settings.resource_group
}

data "azurerm_subnet" "confluent_kafka_gh_runner_subnet" {
  provider             = azurerm.gh_runner
  for_each             = var.cluster_settings.is_multizone_cluster ? local.az_kafka_runner_private_endpoint_subnet_name_by_zone  : { for zone, subnet in local.az_kafka_runner_private_endpoint_subnet_name_by_zone : zone => subnet if zone == "1" }
  name                 = each.value
  virtual_network_name = var.runner_settings.vnet
  resource_group_name  = var.runner_settings.resource_group
}

resource "azurerm_private_endpoint" "confluent_kafka_gh_runner_pvt_endpoint" {
  provider            = azurerm.gh_runner
  for_each            = var.cluster_settings.is_multizone_cluster ? local.az_kafka_runner_private_endpoint_subnet_name_by_zone  : { for zone, subnet in local.az_kafka_runner_private_endpoint_subnet_name_by_zone : zone => subnet if zone == "1" }
  name                = "confluent-${local.network_id}-runner-${each.key}-pvt-endpoint"
  location            = var.runner_settings.region  
  resource_group_name = var.runner_settings.resource_group
  subnet_id           = data.azurerm_subnet.confluent_kafka_gh_runner_subnet[each.key].id

  private_service_connection {
    name                                 = "confluent-${local.network_id}-runner-${each.key}"
    is_manual_connection                 = true
    private_connection_resource_alias    = lookup(confluent_network.private-link.azure[0].private_link_service_aliases, each.key, "\n\nerror: ${each.key} subnet is missing from CCN's Private Link service aliases")
    request_message                      = "PL"
  }
  #   depends_on = [
  #   confluent_private_link_access.azure,
  #   confluent_kafka_cluster_config.cluster_config
  # ]
  lifecycle {
    ignore_changes = [ subnet_id ]
  }
}

resource "azurerm_private_dns_zone" "confluent_kafka_pvt_dns_zone_gh_runner" {
  provider            = azurerm.gh_runner
  resource_group_name = var.runner_settings.resource_group
  name                = local.hosted_zone
}


resource "azurerm_private_dns_zone_virtual_network_link" "confluent_kafka_pvt_dns_zone_gh_runner_vnet_link" {
  provider              = azurerm.gh_runner
  name                  = "${data.azurerm_virtual_network.confluent_kafka_gh_runner_vnet.name}-kafka-runner-dns-link" 
  resource_group_name   = var.runner_settings.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.confluent_kafka_pvt_dns_zone_gh_runner.name
  virtual_network_id    = data.azurerm_virtual_network.confluent_kafka_gh_runner_vnet.id
  # depends_on = [
  #   confluent_private_link_access.azure,
  #   confluent_kafka_cluster_config.cluster_config
  # ]
  lifecycle {
    ignore_changes = [ virtual_network_id ]
  }
}


resource "azurerm_private_dns_a_record" "confluent_kafka_non_zonal_pvt_dns_zone_record_gh_runner" {
  provider            = azurerm.gh_runner
  name                = "*"
  zone_name           = azurerm_private_dns_zone.confluent_kafka_pvt_dns_zone_gh_runner.name
  resource_group_name = var.runner_settings.resource_group
  ttl                 = 60
  records = [
    for _, ep in azurerm_private_endpoint.confluent_kafka_gh_runner_pvt_endpoint : ep.private_service_connection[0].private_ip_address
  ]
}

resource "azurerm_private_dns_a_record" "confluent_kafka_zonal_pvt_dns_zone_record_gh_runner" {
  provider            = azurerm.gh_runner
  for_each            = var.cluster_settings.is_multizone_cluster ? local.az_kafka_runner_private_endpoint_subnet_name_by_zone  : {}
  name                = "*.az${each.key}"
  zone_name           = azurerm_private_dns_zone.confluent_kafka_pvt_dns_zone_gh_runner.name
  resource_group_name = var.runner_settings.resource_group
  ttl                 = 60
  records = [
    azurerm_private_endpoint.confluent_kafka_gh_runner_pvt_endpoint[each.key].private_service_connection[0].private_ip_address,
  ]
}

locals {
  az_kafka_runner_private_endpoint_subnet_name_by_zone  = {"1" = var.runner_settings.pvt_endpoint_subnet_name,"2" = var.runner_settings.pvt_endpoint_subnet_name,"3" = var.runner_settings.pvt_endpoint_subnet_name}
}