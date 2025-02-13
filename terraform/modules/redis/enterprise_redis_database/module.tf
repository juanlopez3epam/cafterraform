resource "azurerm_redis_enterprise_database" "redis" {
  name                = "default"
  resource_group_name = var.redis_cluster[var.settings.primary_cluster_key].resource_group_name #azurerm_redis_enterprise_cluster.redis.resource_group_name
  cluster_id          = var.redis_cluster[var.settings.primary_cluster_key].id                  #azurerm_redis_enterprise_cluster.redis.id
  client_protocol     = var.settings.client_protocol
  clustering_policy   = var.settings.clustering_policy
  eviction_policy     = var.settings.eviction_policy
  port                = var.settings.port

  dynamic "module" {
    for_each = try(var.settings.module == null ? {} : var.settings.module, {})
    content {
      name = module.value.name
      args = module.value.args
    }
  }
  linked_database_id             = local.linked_database_id
  linked_database_group_nickname = var.settings.linked_database_group_nickname
}
