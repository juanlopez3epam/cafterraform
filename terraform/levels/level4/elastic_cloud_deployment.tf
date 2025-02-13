# module "elastic_cloud_deployments" {
#   source = "../../modules/elastic_cloud/ec_deployment"
#   for_each = local.elastic_cloud_deployments  

#   global_settings     = var.global_settings
#   settings            = each.value
#   client_config       = local.client_config
#   resource_groups     = local.consolidated_objects_resource_groups
#   subnets             = local.consolidated_objects_subnets
#   dns_zones           = local.consolidated_objects_private_dns_zones
# }
module "elastic_cloud_deployments" {
  providers = {
    azurerm.gh_runner = azurerm.gh_runner
    azurerm = azurerm
  }
  source = "../../modules/elastic_cloud/ec_deployment"
  for_each = local.elastic_cloud_deployments  

  global_settings     = var.global_settings
  settings            = each.value
  client_config       = local.client_config
  resource_groups     = local.consolidated_objects_resource_groups
  subnets             = local.consolidated_objects_subnets
  dns_zones           = local.consolidated_objects_private_dns_zones
  runner_settings     = local.elastic_cloud_deployments_runner_settings
}

