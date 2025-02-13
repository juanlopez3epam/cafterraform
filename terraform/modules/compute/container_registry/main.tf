
locals {
  tags                = merge(var.base_tags, var.tags)
  resource_group_name = coalesce(var.settings.resource_group_name, var.resource_groups[coalesce(var.settings.resource_group_key, null)].name, null)
}
