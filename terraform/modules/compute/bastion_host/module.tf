resource "azurecaf_name" "host" {
  name          = try(var.settings.name)
  resource_type = "azurerm_bastion_host"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}



resource "azurerm_bastion_host" "host" {
  name                   = azurecaf_name.host.result
  location               = var.global_settings.loc_code
  resource_group_name    = var.resource_groups[var.settings.resource_group_key].name
  sku                    = try(var.settings.sku, null)
  scale_units            = try(var.settings.scale_units, null)
  copy_paste_enabled     = try(var.settings.copy_paste_enabled, null)
  file_copy_enabled      = try(var.settings.file_copy_enabled, null)
  ip_connect_enabled     = try(var.settings.ip_connect_enabled, null)
  shareable_link_enabled = try(var.settings.shareable_link_enabled, null) #only supported when sku is Standard
  tunneling_enabled      = try(var.settings.tunneling_enabled, null)      #only supported when sku is Standard


  ip_configuration {
    name                 = var.settings.name
    subnet_id            = var.virtual_networks[var.settings.vnet_key].subnets[var.settings.subnet_key].id
    public_ip_address_id = var.public_ip_addresses[var.settings.public_ip_key].id
  }

  timeouts {
    create = "60m"
  }
}
