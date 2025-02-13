module "log_analytics" {
  source   = "../../modules/log_analytics"
  for_each = local.log_analytics

  global_settings     = var.global_settings
  log_analytics       = each.value
  location            = var.global_settings.regions.region1
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
}
