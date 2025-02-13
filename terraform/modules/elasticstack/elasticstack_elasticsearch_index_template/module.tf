resource "elasticstack_elasticsearch_index_template" "template" {
  name           = var.settings.name
  index_patterns = var.settings.index_patterns
  priority       = var.settings.priority

  dynamic "template" {
    for_each = var.settings.template == null ? [] : [1]
    content {
      dynamic "alias" {
        for_each = { for alias in try(var.settings.template.aliases, {}) : alias.name => alias }
        content {
          name = alias.value.name
        }
      }
      mappings = var.settings.template.mappings
      settings = var.settings.template.settings
    }
  }
}
