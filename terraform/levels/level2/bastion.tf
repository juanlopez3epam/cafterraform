module "bastion" {
  depends_on = [
    module.public_ip_address,
    module.virtual_network
  ]
  source   = "../../modules/compute/bastion_host"
  for_each = local.bastion_hosts

  global_settings = var.global_settings
  settings        = each.value

  resource_groups     = module.resource_groups
  virtual_networks    = module.virtual_network
  public_ip_addresses = module.public_ip_address

}
