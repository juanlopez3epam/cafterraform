data "azurerm_virtual_network" "elastic_cloud_gh_runner_vnet" {
  provider            = azurerm.gh_runner
  name                = var.runner_settings.vnet
  resource_group_name = var.runner_settings.resource_group
}
data "azurerm_subnet" "elastic_cloud_gh_runner_subnet" {
  provider             = azurerm.gh_runner
  name                 = var.runner_settings.pvt_endpoint_subnet_name
  virtual_network_name = var.runner_settings.vnet
  resource_group_name  = var.runner_settings.resource_group
}
resource "azurerm_private_endpoint" "elastic_cloud_gh_runner_pvt_endpoint" {
  provider            = azurerm.gh_runner
  name                = "${var.global_settings.env_short_code}-elastic-cloud-${var.ec_region}-runner-pe"
  location            = var.runner_settings.region  
  resource_group_name = var.runner_settings.resource_group
  subnet_id           = data.azurerm_subnet.elastic_cloud_gh_runner_subnet.id
  private_service_connection {
    name                                 = "elastic-cloud-${var.ec_region}-runner-pvt-endpoint"
    is_manual_connection                 = true
    private_connection_resource_alias    = var.ec_privatelink
    request_message                      = "Azure Private Link"
  }
}
resource "azurerm_private_dns_zone" "elastic_cloud_pvt_dns_zone_gh_runner" {
  count               = var.create_ec_gh-runner_privatelink ? 1:0
  provider            = azurerm.gh_runner
  resource_group_name = var.runner_settings.resource_group
  name                = local.hosted_zone
}

resource "azurerm_private_dns_zone_virtual_network_link" "elastic_cloud_pvt_dns_zone_gh_runner_vnet_link" {
  depends_on            = [ azurerm_private_endpoint.elastic_cloud_gh_runner_pvt_endpoint ]
  count                 = var.create_ec_gh-runner_privatelink ? 1:0
  provider              = azurerm.gh_runner
  name                  = "${data.azurerm_virtual_network.elastic_cloud_gh_runner_vnet.name}-ec-runner-dns-link" 
  resource_group_name   = var.runner_settings.resource_group
  private_dns_zone_name = local.hosted_zone
  virtual_network_id    = data.azurerm_virtual_network.elastic_cloud_gh_runner_vnet.id
}
resource "azurerm_private_dns_a_record" "elastic_cloud_dns_zone_record_gh_runner" {
  provider            = azurerm.gh_runner
  name                = var.ec_search_id
  zone_name           = local.hosted_zone
  resource_group_name = var.runner_settings.resource_group
  ttl                 = 60
  records             = [azurerm_private_endpoint.elastic_cloud_gh_runner_pvt_endpoint.private_service_connection[0].private_ip_address]
}


locals {
  private_endpoint_name = azurerm_private_endpoint.elastic_cloud_gh_runner_pvt_endpoint.name
}

data "azapi_resource" "private_endpoint_elasticsearch" {
  type                   = "Microsoft.Network/privateEndpoints@2019-02-01"
  resource_id            = azurerm_private_endpoint.elastic_cloud_gh_runner_pvt_endpoint.id
  response_export_values = ["properties.resourceGuid"]
}

resource "ec_deployment_traffic_filter" "gh_runner_pe_network_filter" {
  name       = "${local.private_endpoint_name}-gh-runner-pe-traffic-filter"
  region     = var.settings.region
  type       = "azure_private_endpoint"

  rule {
    azure_endpoint_name = local.private_endpoint_name
    azure_endpoint_guid = jsondecode(data.azapi_resource.private_endpoint_elasticsearch.output).properties.resourceGuid
  }
}

resource "ec_deployment_traffic_filter_association" "gh_runner_pe_network_filter_association" {
  traffic_filter_id = ec_deployment_traffic_filter.gh_runner_pe_network_filter.id
  deployment_id     = local.ec_cluster_id
}

locals {
  hosted_zone = var.settings.private_endpoint.private_dns["pe"].dns_zone_key
  network_id  = regex("^([^.]+)[.].*", local.hosted_zone)[0]
  ec_cluster_id = var.ec_id
}