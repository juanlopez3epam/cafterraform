resource "azurecaf_name" "ddos_protection_plan" {
  for_each = local.ddos_protection_plan

  name          = try(each.value.name, null)
  resource_type = "azurerm_network_ddos_protection_plan"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_network_ddos_protection_plan" "ddos_protection_plan" {
  for_each = local.ddos_protection_plan

  name                = azurecaf_name.ddos_protection_plan[each.key].result
  location            = var.global_settings.regions.region1
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  tags                = {}
}


module "public_ip_address" {
  source          = "../../modules/networking/public_ip"
  for_each        = local.public_ip_addresses
  global_settings = var.global_settings
  settings        = each.value
  resource_group  = module.resource_groups[each.value.resource_group_key]
}


module "virtual_network" {
  source                            = "../../modules/networking/virtual_network"
  for_each                          = local.virtual_networks
  global_settings                   = var.global_settings
  settings                          = each.value
  resource_group                    = module.resource_groups[each.value.resource_group_key]
  ddos_protection_plan              = try(each.value.ddos_protection_plan.ddos_protection_plan_key, null) != null ? local.consolidated_objects_ddos_protection_plans[coalesce(try(each.value.ddos_protection_plan.lz_key, null), local.client_config.landingzone_key)][each.value.ddos_protection_plan.ddos_protection_plan_key] : null
  network_security_group_definition = local.network_security_group_definition
  route_tables                      = module.route_tables
}

module "route_tables" {
  source = "../../modules/networking/route_tables"

  for_each = local.route_tables

  global_settings = var.global_settings

  name                          = each.value.name
  resource_group_name           = local.consolidated_objects_resource_groups[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.resource_group_key].name
  location                      = local.consolidated_objects_resource_groups[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.resource_group_key].location
  disable_bgp_route_propagation = try(each.value.disable_bgp_route_propagation, null) != null ? each.value.disable_bgp_route_propagation : false
}

module "routes" {
  source = "../../modules/networking/routes"

  for_each = local.routes

  global_settings = merge(var.global_settings, {
    prefixes = []
    suffixes = []
  })

  name                   = each.value.name
  resource_group_name    = module.route_tables[each.value.route_table_key].resource_group_name
  route_table_name       = module.route_tables[each.value.route_table_key].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
}


module "virtual_wan" {
  source              = "../../modules/networking/virtual_wan"
  for_each            = local.virtual_wans
  global_settings     = var.global_settings
  settings            = each.value
  location            = var.global_settings.regions.region1
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
}

module "virtual_hub" {
  depends_on          = [module.firewall_policies]
  source              = "../../modules/networking/virtual_wan/virtual_hub"
  for_each            = local.virtual_hubs
  global_settings     = var.global_settings
  settings            = each.value
  location            = var.global_settings.regions.region1
  resource_group_name = module.resource_groups[each.value.resource_group.key].name
  virtual_networks    = module.virtual_network
  vwan_id             = module.virtual_wan[each.value.virtual_wan.key].id
}

module "firewall_policies" {
  source     = "../../modules/networking/firewall_policies"
  depends_on = [module.private_dns_resolver]
  for_each   = local.firewall_policies

  global_settings = var.global_settings
  settings        = each.value

  resource_group  = module.resource_groups[each.value.resource_group_key]
  dns_resolver_ip = try(module.private_dns_resolver[each.value.dns.dns_resolver_key].inbound_endpoints[each.value.dns.inbound_endpoint_key].private_ip_address, null)
}

module "firewall" {
  depends_on = [
    module.firewall_policies
  ]
  source   = "../../modules/networking/firewall"
  for_each = local.firewalls

  global_settings = var.global_settings
  settings        = each.value

  location = var.global_settings.regions.region1

  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  virtual_hubs        = module.virtual_hub
  firewall_policies   = module.firewall_policies
}

module "private_dns_zone" {
  depends_on = [
    module.virtual_network
  ]
  source   = "../../modules/networking/private_dns"
  for_each = local.services_by_private_link_dns_zone

  name                = each.key
  global_settings     = var.global_settings
  resource_group_name = module.resource_groups[try(local.private_dns_zones[each.key].resource_group_key, local.private_dns_zones["all"].resource_group_key)].name
  vnet_links          = try(local.private_dns_zones[each.key].vnet_links, local.private_dns_zones["all"].vnet_links)
  virtual_networks    = local.consolidated_objects_virtual_networks
  client_config       = local.client_config
  tags                = try(local.private_dns_zones[each.key].tags, local.private_dns_zones["all"].tags, {})
}

module "private_dns_resolver" {
  depends_on = [
    module.virtual_network
  ]
  source           = "../../modules/networking/private_dns_resolver"
  for_each         = local.private_dns_resolvers
  global_settings  = var.global_settings
  settings         = each.value
  resource_group   = module.resource_groups[each.value.resource_group_key]
  virtual_networks = module.virtual_network
}
