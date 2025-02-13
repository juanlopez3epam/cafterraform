# Name of the VM in the Azure Control Plane
resource "azurecaf_name" "legacy" {
  for_each = local.os_type == "legacy" ? var.settings.virtual_machine_settings : {}

  name          = each.value.name
  resource_type = "azurerm_virtual_machine"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


# Name of the Linux computer name
resource "azurecaf_name" "legacy_computer_name" {
  depends_on = [azurerm_network_interface.nic, azurerm_network_interface_security_group_association.nic_nsg]
  for_each   = local.os_type == "legacy" ? var.settings.virtual_machine_settings : {}

  name          = try(each.value.computer_name, each.value.name)
  resource_type = "azurerm_virtual_machine"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}
