resource "azurecaf_name" "vnet" {
  name          = var.settings.vnet.name
  resource_type = "azurerm_virtual_network"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_virtual_network" "vnet" {
  name                = azurecaf_name.vnet.result
  resource_group_name = var.resource_group.name
  location            = var.global_settings.regions[lookup(var.settings, "region", var.global_settings.default_region)]
  address_space       = var.settings.vnet.address_space
  dns_servers         = var.dns_servers
  tags                = try(lookup(var.settings, "tags"), {})

  dynamic "ddos_protection_plan" {
    # Using splat operator to convert single value into a list
    for_each = var.ddos_protection_plan[*]

    content {
      id     = var.ddos_protection_plan.id
      enable = true
    }
  }


  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "subnets" {
  source                                        = "./subnet"
  for_each                                      = lookup(var.settings, "subnets", {})
  name                                          = each.value.name
  global_settings                               = var.global_settings
  resource_group_name                           = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = lookup(each.value, "cidr", [])
  service_endpoints                             = lookup(each.value, "service_endpoints", [])
  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", false)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", false)
  settings                                      = each.value
}

module "nsg" {
  source                            = "./nsg"
  application_security_groups       = var.application_security_groups
  global_settings                   = var.global_settings
  location                          = azurerm_virtual_network.vnet.location
  network_security_group_definition = var.network_security_group_definition
  resource_group_name               = var.resource_group.name
  subnets                           = try(var.settings.subnets, {})
}

resource "azurerm_subnet_route_table_association" "rt" {
  for_each = {
    for key, subnet in try(var.settings.subnets, {}) : key => subnet
    if try(subnet.route_table_key, null) != null
  }

  subnet_id      = module.subnets[each.key].id
  route_table_id = var.route_tables[each.value.route_table_key].id
}

resource "azurerm_subnet_network_security_group_association" "nsg_vnet_association" {
  for_each = {
    for key, value in try(var.settings.subnets, {}) : key => value
    if try(var.network_security_group_definition[value.nsg_key].version, 0) == 0 && try(value.nsg_key, null) != null
  }

  subnet_id                 = module.subnets[each.key].id
  network_security_group_id = module.nsg.nsg_obj[each.key].id
}
