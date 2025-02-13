module "elastic_cloud" {
  source = "../../modules/databases/elastic_cloud"

  for_each = local.elastic_cloud

  resource_group = local.consolidated_objects_resource_groups[coalesce(try(each.value.lz_key, null), local.client_config.landingzone_key)][each.value.resource_group_key]
  settings       = each.value
}
