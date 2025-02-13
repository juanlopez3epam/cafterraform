resource "azurerm_role_assignment" "for" {
  for_each = {
    for key, value in local.roles_to_process : key => value
    if contains(keys(local.services_roles), value.scope_resource_key)
  }

  principal_id         = each.value.object_id_resource_type == "object_ids" ? each.value.object_id_key_resource : each.value.object_id_lz_key == null ? local.services_roles[each.value.object_id_resource_type][var.client_config.landingzone_key][each.value.object_id_key_resource][each.value.object_id_property] : local.services_roles[each.value.object_id_resource_type][each.value.object_id_lz_key][each.value.object_id_key_resource][each.value.object_id_property]
  role_definition_id   = each.value.mode == "custom_role_mapping" ? var.custom_roles[each.value.role_definition_name].role_definition_resource_id : null
  role_definition_name = each.value.mode == "built_in_role_mapping" ? each.value.role_definition_name : null
  scope                = each.value.scope_lz_key == null ? local.services_roles[each.value.scope_resource_key][var.client_config.landingzone_key][each.value.scope_key_resource].id : local.services_roles[each.value.scope_resource_key][each.value.scope_lz_key][each.value.scope_key_resource].id
}

resource "time_sleep" "azurerm_role_assignment_for" {
  depends_on = [azurerm_role_assignment.for]
  count = length(
    {
      for key, value in try(local.roles_to_process, {}) : key => value
      if contains(keys(local.services_roles), value.scope_resource_key)
    }
  ) > 0 ? 1 : 0

  # 2 mins timer on creation
  create_duration = "2m"
}

resource "azurerm_role_assignment" "external_resources" {
  for_each = {
    for key, value in local.roles_to_process : key => value
    if value.scope_resource_key == "external_resources"
  }

  principal_id         = each.value.object_id_resource_type == "object_ids" ? each.value.object_id_key_resource : each.value.object_id_lz_key == null ? local.services_roles[each.value.object_id_resource_type][var.client_config.landingzone_key][each.value.object_id_key_resource][each.value.object_id_property] : local.services_roles[each.value.object_id_resource_type][each.value.object_id_lz_key][each.value.object_id_key_resource][each.value.object_id_property]
  role_definition_id   = each.value.mode == "custom_role_mapping" ? var.custom_roles[each.value.role_definition_name].role_definition_resource_id : null
  role_definition_name = each.value.mode == "built_in_role_mapping" ? each.value.role_definition_name : null
  scope                = each.value.scope_key_resource
}

resource "time_sleep" "azurerm_role_assignment_external_resources" {
  depends_on = [azurerm_role_assignment.external_resources]
  count = length(
    {
      for key, value in try(local.roles_to_process, {}) : key => value
      if value.scope_resource_key == "external_resources"
    }
  ) > 0 ? 1 : 0

  # 2 mins timer on creation
  create_duration = "2m"
}
