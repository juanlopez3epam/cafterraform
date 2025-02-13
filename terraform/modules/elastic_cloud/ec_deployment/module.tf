resource "ec_deployment" "cluster" {
  name                   = var.settings.name
  region                 = var.settings.region
  version                = var.settings.version
  deployment_template_id = var.settings.deployment_template_id
  elasticsearch          = var.settings.elasticsearch
}

data "ec_azure_privatelink_endpoint" "ec_private_link" {
  region = split("azure-", var.settings.region)[1]
}
module "private_endpoints" {
  source              = "../../networking/private_endpoint"
  depends_on          = [ec_deployment.cluster]
  resource_alias      = data.ec_azure_privatelink_endpoint.ec_private_link.service_alias
  global_settings     = var.global_settings
  client_config       = var.client_config
  subnets             = var.subnets
  dns_zones           = var.dns_zones
  resource_group_name = var.resource_groups[var.client_config.landingzone_key][var.settings.resource_group_key].name
  location            = split("azure-", ec_deployment.cluster.region)[1]
  settings            = var.settings.private_endpoint
}

resource "azurerm_private_dns_a_record" "elastic_cloud_dns_zone_record" {
  depends_on          = [module.private_endpoints]
  name                = "*"
  zone_name           = var.settings.private_endpoint.private_dns["pe"].dns_zone_key
  resource_group_name = var.settings.private_dns_zone_rg
  ttl                 = 60
  records = [
    "${module.private_endpoints.private_ip_address}"
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "elastic_cloud_dns_zone_vnet_links" {
  name                  = "${var.settings.name}-elastic-cloud-dns-link"
  resource_group_name   = var.settings.private_dns_zone_rg
  private_dns_zone_name = var.settings.private_endpoint.private_dns["pe"].dns_zone_key
  virtual_network_id    = var.settings.base_vnet_id
}

# data "external" "az_graph_query" {
#   depends_on = [module.private_endpoints]
#   program = ["bash", "-c", <<-EOF
#     #!/bin/bash
#     set -e
#     PE_NAME="${module.private_endpoints.name}"
#     SUBSCRIPTION_ID="${var.global_settings.default_subscription_id}"
#     az account set --subscription "$SUBSCRIPTION_ID"
#     QUERY="Resources | where type == 'microsoft.network/privateendpoints' | where name == '$PE_NAME'"
#     PE_GUID=$(az graph query -q "$QUERY" --output json | jq -r '.data[0].properties.resourceGuid')
#     echo "{\"output\": \"$PE_GUID\"}"
#     EOF
#   ]
# }
data "azapi_resource" "private_endpoint_elasticsearch" {
  type                   = "Microsoft.Network/privateEndpoints@2019-02-01"
  resource_id            = module.private_endpoints.id
  response_export_values = ["properties.resourceGuid"]
}

resource "ec_deployment_traffic_filter" "pe_network_filter" {
  name       = "${var.settings.name}-pe-traffic-filter"
  region     = var.settings.region
  type       = "azure_private_endpoint"

  rule {
    azure_endpoint_name = module.private_endpoints.name
    azure_endpoint_guid = jsondecode(data.azapi_resource.private_endpoint_elasticsearch.output).properties.resourceGuid
  }
}

resource "ec_deployment_traffic_filter_association" "pe_network_filter_association" {
  traffic_filter_id = ec_deployment_traffic_filter.pe_network_filter.id
  deployment_id     = ec_deployment.cluster.id
}

locals {
  create_gh_runner_private_network = var.runner_settings.create_runner_pe
}
module "gh_runner_private_network" {
  source          = "./gh_runner"
  providers = {
    azurerm.gh_runner = azurerm.gh_runner
    azurerm = azurerm
  }
  create_ec_gh-runner_privatelink =  local.create_gh_runner_private_network
  client_config                   = var.client_config
  global_settings                 = var.global_settings
  settings                        = var.settings
  runner_settings                 = var.runner_settings
  subnets                         = var.subnets
  ec_id                           = ec_deployment.cluster.id
  ec_search_id                    = ec_deployment.cluster.elasticsearch.resource_id
  ec_region                       = ec_deployment.cluster.region
  ec_privatelink                  = data.ec_azure_privatelink_endpoint.ec_private_link.service_alias
}


locals {
  hosted_zone = var.settings.private_endpoint.private_dns["pe"].dns_zone_key
}