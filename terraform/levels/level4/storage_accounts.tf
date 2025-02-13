module "storage_accounts" {
  source = "../../modules/storage_account"

  for_each = local.storage_accounts

  global_settings = var.global_settings
  client_config   = local.client_config

  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  storage_account     = each.value
  location            = var.global_settings.regions[lookup(each.value, "region", var.global_settings.default_region)]
  base_tags           = module.resource_groups[each.value.resource_group_key].tags
  subnets             = local.consolidated_objects_subnets
  dns_zones           = local.consolidated_objects_private_dns_zones
}
