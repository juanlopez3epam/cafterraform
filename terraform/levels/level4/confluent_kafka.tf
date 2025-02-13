module "confluent_cloud_deployments" {
  
  # depends_on = [
  #   module.keyvaults,
  # ]
  
    providers = {
    azurerm.gh_runner = azurerm.gh_runner
    azurerm = azurerm
  }

  source = "../../modules/compute/confluent_kafka"
  
  depends_on = [
    module.resource_groups,
    module.keyvaults,
    module.dynamic_keyvault_secrets,
    module.subnets,
    module.route_tables,
    module.routes,
    azurerm_subnet_route_table_association.rt
  ]

  for_each = local.confluent_cloud_deployments_cluster_settings

  cluster_settings    = each.value
  runner_settings     = local.confluent_cloud_deployments_runner_settings
  global_settings     = var.global_settings
  client_config       = local.client_config
  keyvaults           = local.consolidated_objects_keyvaults
  vnets               = local.virtual_networks
}
