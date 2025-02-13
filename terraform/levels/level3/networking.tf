module "virtual_network" {
  source = "../../modules/networking/virtual_network"

  for_each = local.virtual_networks

  global_settings = var.global_settings
  settings        = each.value

  resource_group = module.resource_group[each.value.resource_group_key]

  ddos_protection_plan = try(each.value.ddos_protection_plan.ddos_protection_plan_key, null) != null ? local.consolidated_objects_ddos_protection_plans[coalesce(try(each.value.ddos_protection_plan.lz_key, null), local.client_config.landingzone_key)][each.value.ddos_protection_plan.ddos_protection_plan_key] : null

  dns_servers = try(each.value.dns.dns_server_ips, null)
}


module "virtual_hub_connections" {
  source = "../../modules/networking/virtual_wan/virtual_hub_connection"
  providers = {
    azurerm = azurerm.connectivity
  }

  for_each = local.virtual_hub_connections

  global_settings = var.global_settings
  settings        = each.value

  virtual_hub_id = local.level_2.vhub[each.value.vhub_key].id

  remote_virtual_network_id = module.virtual_network[each.value.vnet_key].id
}

module "private_dns_zone" {
  depends_on = [
    module.virtual_network
  ]
  source   = "../../modules/networking/private_dns"
  for_each = local.private_dns_zones

  name                = each.value.name
  global_settings     = var.global_settings
  resource_group_name = local.consolidated_objects_resource_groups[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.resource_group_key].name
  vnet_links          = each.value.vnet_links
  virtual_networks    = local.consolidated_objects_virtual_networks
  client_config       = local.client_config
  tags                = try(each.value.tags, {})
}

module "private_dns_zone_vnet_link" {
  depends_on = [
    module.virtual_network
  ]
  source   = "../../modules/networking/private_dns/vnet_link"
  for_each = local.private_dns_vnet_links

  name                  = each.value.vnet_key
  global_settings       = var.global_settings
  resource_group_name   = local.consolidated_objects_resource_groups[coalesce(try(each.value.resource_group_lz_key, null), local.client_config.landingzone_key)][each.value.resource_group_key].name
  virtual_network_id    = local.consolidated_objects_virtual_networks[coalesce(try(each.value.vnet_lz_key, null), local.client_config.landingzone_key)][each.value.vnet_key].id
  private_dns_zone_name = each.value.name
  registration_enabled  = try(each.value.registration_enabled, false)
  tags                  = try(each.value.tags, {})
}

module "public_ip_address" {
  source          = "../../modules/networking/public_ip"
  for_each        = local.public_ip_addresses
  global_settings = var.global_settings
  settings        = each.value
  resource_group  = local.consolidated_objects_resource_groups[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.resource_group_key]
}