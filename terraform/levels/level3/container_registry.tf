module "container_registries" {
  source = "../../modules/compute/container_registry"

  for_each = local.container_registries

  global_settings = var.global_settings
  settings        = each.value

  name                          = each.value.name
  sku                           = try(each.value.sku, null)
  admin_enabled                 = try(each.value.admin_enabled, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, null)
  georeplications               = try(each.value.georeplications, null)
  network_rule_set              = try(each.value.network_rule_set, null)
  tags                          = try(each.value.tags, null)


  resource_groups = module.resource_group

}

# Temporary RBAC assignment for container registries until the level is updated to support RBAC assignments
resource "azurerm_role_assignment" "container_registries_rbac_temp" {
  for_each = local.container_registries

  scope                = module.container_registries[each.key].id
  role_definition_name = "Contributor"
  principal_id         = "3fabd666-ad4f-429f-b591-e33b1763b16e"
}
