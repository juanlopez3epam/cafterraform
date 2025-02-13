module "subnets" {
  source = "../../modules/networking/virtual_network/subnet"

  for_each = local.filtered_subnets 

  global_settings = merge(var.global_settings, {
    prefixes = []
    suffixes = []
  })

  settings = each.value

  name              = each.value.name
  address_prefixes  = each.value.cidr
  service_endpoints = try(each.value.service_endpoints, null) != null ? each.value.service_endpoints : []

  resource_group_name = local.level_3.vnets[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.vnet_key].resource_group_name

  virtual_network_name = local.level_3.vnets[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.vnet_key].name

}

resource "azurerm_subnet_route_table_association" "rt" {
  for_each = {
    for key, value in local.subnets : key => value
    if try(value.route_table_key, null) != null
  }

  subnet_id      = module.subnets[each.key].id
  route_table_id = module.route_tables[each.value.route_table_key].id
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

  name                = each.value.name
  resource_group_name = module.route_tables[each.value.route_table_key].resource_group_name
  route_table_name    = module.route_tables[each.value.route_table_key].name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
}

module "cdn" {
  source = "../../modules/networking/cdn"

  for_each = local.cdn

  settings = each.value

  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  global_settings     = var.global_settings
  location            = "global"
}