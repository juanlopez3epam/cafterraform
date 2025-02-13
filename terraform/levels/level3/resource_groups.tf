module "resource_group" {
  source = "../../modules/resource_group"

  for_each = local.resource_groups

  global_settings = var.global_settings
  settings        = each.value
  tags            = each.value.tags

}
