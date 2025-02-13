resource "elasticstack_elasticsearch_index" "index" {
  name               = var.settings.name
  mappings           = var.settings.mappings
  number_of_replicas = var.settings.number_of_replicas
  number_of_shards   = var.settings.number_of_shards

  dynamic "alias" {
    for_each = { for alias in try(var.settings.aliases, {}) : alias.name => alias }
    content {
      name = alias.value.name
    }
  }
  analysis_normalizer = var.settings.analysis_normalizer
}
