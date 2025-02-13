resource "elasticstack_elasticsearch_security_role" "role" {
  name    = var.settings.name
  cluster = var.settings.cluster
  run_as  = var.settings.run_as

  dynamic "indices" {
    for_each = var.settings.indices
    content {
      names      = indices.value.names
      privileges = indices.value.privileges
      dynamic "field_security" {
        for_each = indices.value.field_security == null ? [] : [1]
        content {
          grant  = indices.value.field_security.grant
          except = indices.value.field_security.except
        }
      }
      query = indices.value.query
    }
  }

  dynamic "applications" {
    for_each = var.settings.applications
    content {
      application = applications.value.application
      privileges  = applications.value.privileges
      resources   = applications.value.resources
    }
  }
}
