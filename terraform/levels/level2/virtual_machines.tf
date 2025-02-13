module "virtual_machines" {
  depends_on = [
    module.public_ip_address,
    module.virtual_network,
    module.keyvaults,
    module.keyvault_access_policies
  ]
  source   = "../../modules/compute/virtual_machine"
  for_each = local.virtual_machines

  global_settings         = var.global_settings
  settings                = each.value
  location                = module.resource_groups[each.value.resource_group_key].location
  resource_group_name     = module.resource_groups[each.value.resource_group_key].name
  vnets                   = module.virtual_network
  keyvaults               = module.keyvaults
  public_ip_addresses     = module.public_ip_address
  network_security_groups = local.network_security_group_definition
  managed_identities      = module.managed_identities

}
